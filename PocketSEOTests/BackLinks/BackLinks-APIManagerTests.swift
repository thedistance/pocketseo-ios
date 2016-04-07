//
//  BackLinks-APIManagerTests.swift
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

class BackLinks_APIManagerTests: XCTestCase {

    let apiManager = APIManager(urlStore: TestURLStore())
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    // ASH: Create JSON with 35 links in (so the results span 2 pages). Create 2 hard coded instances of BackLink class that matches one link in each page of the results.
    
    // test the default limit is observed
    func testBackLinks() {
        
        let found = MutableProperty<[BackLink]?>(nil)
        
        found <~ apiManager.linksForString("test", page: 0)
            .observeOn(UIScheduler())
            .flatMapError({ (error) -> SignalProducer<[BackLink], NoError> in
                XCTFail("Failed to get mozscape metrics")
                return SignalProducer.empty
            })
            .map { $0 as [BackLink]? }
     
        let expected = BackLink.distanceBackLink()
        
        expect(found.value?.count).toEventually(equal(25))
        expect(found.value?[5]).toEventually(contentEqual(expected))
    }
    
    // test the page is observed
    func testBacklinkesPage() {
        
        let found = MutableProperty<[BackLink]?>(nil)
        
        found <~ apiManager.linksForString("test", page: 1)
            .observeOn(UIScheduler())
            .flatMapError({ (error) -> SignalProducer<[BackLink], NoError> in
                XCTFail("Failed to get mozscape metrics")
                return SignalProducer.empty
            })
            .map { $0 as [BackLink]? }
        
        let expected = BackLink.distanceBackLink()
        
        expect(found.value?.count).toEventually(equal(10))
        expect(found.value?[1]).toEventually(contentEqual(expected))
    }
}
