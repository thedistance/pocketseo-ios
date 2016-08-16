//
//  BackLinks-ViewModelTests.swift
//  MozQuito
//
//  Created by Josh Campion on 06/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest

import ReactiveCocoa
import Result
import Nimble

@testable import PocketSEO

extension XCTestCase {
    
    /**
     
     Creates an `XCTExpectation` which fulfils after a given time interval and waits for it.
     
     - parameter time: The time to wait for. Default value is 0.25.
     - parameter withDescription: The description for the `XCTExpectation`.
     
    */
    func waitForTime(time:NSTimeInterval = 0.25, withDescription description:String) {
        
        // wait to see if there are no events sent after a possible refresh
        let waitExpectation = expectationWithDescription(description)
        waitExpectation.performSelector(#selector(XCTestExpectation.fulfill), withObject: nil, afterDelay: time)
        waitForExpectationsWithTimeout(time + 0.15, handler: nil)
        
    }
    
}

class BackLinks_ViewModelTests: XCTestCase {

    var errors = MutableProperty<NSError?>(nil)
    var found = MutableProperty<LinksOutput?>(nil)
    
    let viewModel = MozscapeLinksViewModel(apiManager: APIManager(urlStore: TestURLStore()))
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        errors = MutableProperty<NSError?>(nil)
        
        errors <~ viewModel.errorSignal
            .observeOn(UIScheduler())
            .map({ $0 as NSError? })
        
        found = MutableProperty<LinksOutput?>(nil)
        
        found <~ viewModel.contentChangesSignal
            .observeOn(UIScheduler())
            .map({ $0 as LinksOutput? })

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // test no content is loaded on willAppear
    func testEmptyWillAppear() {
        
        viewModel.viewLifetime.value = .WillAppear
        
        waitForTime(withDescription: #function)
        
        expect(self.found.value).to(beNil())
        expect(self.errors.value).to(beNil())
    }
    
    func testInitialPage() {
        
        let expected = MZMozscapeLinks.theDistanceLinks()
        
        viewModel.urlString.value = "thedistance.co.uk"

        expect(self.found.value?.currentContent.count).toEventually(equal(25))
        expect(self.found.value?.currentContent[2]).toEventually(contentEqual(expected))
        expect(self.found.value?.moreAvailable).toEventually(beTrue())
        
        waitForTime(withDescription: #function)
        expect(self.errors.value).to(beNil())
    }
    
    func testNextPageLoad() {
        
        errors.producer.startWithNext { (error) in
            if let e = error {
                XCTFail("Errored getting page: \(e)")
            }
        }
        
        var foundExpectation:XCTestExpectation? = expectationWithDescription(#function + "Page")
        found.producer.startWithNext {
            if $0 != nil {
                foundExpectation?.fulfill()
                foundExpectation = nil
            }
        }
        
        viewModel.urlString.value = "thedistance.co.uk"
        
        waitForExpectationsWithTimeout(1) { (error) in
            if let e = error {
                XCTFail("Failed to load first page: \(e)")
            }
        }
        
        let expected1 = MZMozscapeLinks.theDistanceLinks()
        let expected2 = MZMozscapeLinks.theDistanceLinks1()
        
        viewModel.refreshObserver.sendNext(true)
        
        expect(self.found.value?.currentContent.count).toEventually(equal(35))
        expect(self.found.value?.currentContent[2]).toEventually(contentEqual(expected1))
        expect(self.found.value?.currentContent[26]).toEventually(contentEqual(expected2))
        expect(self.found.value?.moreAvailable).toEventually(beFalse())
        
        waitForTime(withDescription: #function + "Error")
        
        expect(self.errors.value).to(beNil())
    }
    
    func testPageReload() {
        
        errors.producer.startWithNext { (error) in
            if let e = error {
                XCTFail("Errored getting page: \(e)")
            }
        }
        
        var foundExpectation:XCTestExpectation? = expectationWithDescription(#function + "Page")
        found.producer.startWithNext {
            if $0 != nil {
                foundExpectation?.fulfill()
                foundExpectation = nil
            }
        }
        
        viewModel.urlString.value = "thedistance.co.uk"
        
        waitForExpectationsWithTimeout(1) { (error) in
            if let e = error {
                XCTFail("Failed to load first page: \(e)")
            }
        }
        
        let expected1 = MZMozscapeLinks.theDistanceLinks()
        
        viewModel.refreshObserver.sendNext(false)
        
        expect(self.found.value?.currentContent.count).toEventually(equal(25))
        expect(self.found.value?.currentContent[2]).toEventually(contentEqual(expected1))
        expect(self.found.value?.moreAvailable).toEventually(beTrue())
        
        waitForTime(withDescription: #function + "Error")
        
        expect(self.errors.value).to(beNil())
    }

    func testNewPageLoad() {
        
        let parameters = LinkSearchConfiguration.defaultConfiguration()
        
        errors.producer.startWithNext { (error) in
            if let e = error {
                XCTFail("Errored getting page: \(e)")
            }
        }
        
        var foundExpectation:XCTestExpectation? = expectationWithDescription(#function + "Page")
        found.producer.startWithNext {
            if $0 != nil {
                foundExpectation?.fulfill()
                foundExpectation = nil
            }
        }
        
        viewModel.urlString.value = "thedistance.co.uk"
        
        waitForExpectationsWithTimeout(1) { (error) in
            if let e = error {
                XCTFail("Failed to load first page: \(e)")
            }
        }
        
        let expected1 = MZMozscapeLinks.theDistanceLinks()
        
        viewModel.urlString.value = "slimmingworld.co.uk"
        
        expect(self.found.value?.currentContent.count).toEventually(equal(25))
        expect(self.found.value?.currentContent[2]).toEventually(contentEqual(expected1))
        expect(self.found.value?.moreAvailable).toEventually(beTrue())
        
        waitForTime(withDescription: #function + "Error")
        
        expect(self.errors.value).to(beNil())
    }

}
