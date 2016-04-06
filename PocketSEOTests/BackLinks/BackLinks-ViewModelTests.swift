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

class BackLinks_ViewModelTests: XCTestCase {

    let viewModel = LinksViewModel(apiManager: APIManager(urlStore: TestURLStore()))
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // test no content is loaded on willAppear
    func testEmptyWillAppear() {
        
        let found = MutableProperty<LinksOutput?>(nil)
        let errors = MutableProperty<NSError?>(nil)
        
        found <~ viewModel.contentChangesSignal
            .observeOn(UIScheduler())
            .map({ $0 as LinksOutput? })
        
        errors <~ viewModel.errorSignal
            .observeOn(UIScheduler())
            .map({ $0 as NSError? })
        
        // Note this test doesn't validate this...
        expect(found.value).toEventually(beNil())
        expect(errors.value).toEventually(beNil())
    }
    
    func testInitialPage() {
        
        let found = MutableProperty<LinksOutput?>(nil)
        let errors = MutableProperty<NSError?>(nil)
        
        found <~ viewModel.contentChangesSignal
            .observeOn(UIScheduler())
            .map({ $0 as LinksOutput? })
        
        errors <~ viewModel.errorSignal
            .observeOn(UIScheduler())
            .map({ $0 as NSError? })

        let expected = BackLink.distanceBackLink()
        
        viewModel.refreshObserver.sendNext((urlRequest: "thedistance.co.uk", nextPage: true))

        expect(found.value?.links.count).toEventually(equal(25))
        expect(found.value?.links[5]).toEventually(contentEqual(expected))
        expect(found.value?.moreAvailable).toEventually(beTrue())
        
        expect(errors.value).toEventuallyNot(beTruthy())
    }
    
    func testNextPageLoad() {
        
        let found = MutableProperty<LinksOutput?>(nil)
        let errors = MutableProperty<NSError?>(nil)
        
        found <~ viewModel.contentChangesSignal
            .observeOn(UIScheduler())
            .map({ $0 as LinksOutput? })
        
        errors <~ viewModel.errorSignal
            .observeOn(UIScheduler())
            .map({ $0 as NSError? })
        
        
        
        let foundExpectation = expectationWithDescription(#function)
        found.producer.startWithNext {
            if $0 != nil {
                foundExpectation.fulfill()
            }
        }
        
        viewModel.refreshObserver.sendNext((urlRequest: "thedistance.co.uk", nextPage: true))
        
        waitForExpectationsWithTimeout(1) { (error) in
            if let e = error {
                XCTFail("Failed to load first page: \(e)")
            }
        }
        
        let expected1 = BackLink.distanceBackLink()
        let expected2 = BackLink.distanceBackLink()
        
        viewModel.refreshObserver.sendNext((urlRequest: "thedistance.co.uk", nextPage: true))
        
        expect(found.value?.links.count).toEventually(equal(35))
        expect(found.value?.links[5]).toEventually(contentEqual(expected1))
        expect(found.value?.links[26]).toEventually(contentEqual(expected2))
        expect(found.value?.moreAvailable).toEventually(beFalse())
    }
    
}
