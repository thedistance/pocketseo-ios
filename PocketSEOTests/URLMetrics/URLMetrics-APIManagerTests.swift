//
//  URLMetrics-APIManager.swift
//  MozQuito
//
//  Created by Josh Campion on 04/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest

import ReactiveCocoa
import Result
import Nimble

@testable import PocketSEO

class URLMetrics_APIManager: XCTestCase {
    
    let apiManager = APIManager(urlStore: TestURLStore())
    let emptyAPIManager = APIManager(urlStore: EmptyURLStore())
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMozscapeMetrics() {
        
        let metrics = MutableProperty<MZMozscapeMetrics?>(nil)
        
        metrics <~ apiManager.mozscapeURLMetricsForString("thedistance.co.uk")
            .observeOn(UIScheduler())
            .flatMapError({ (error) -> SignalProducer<MZMozscapeMetrics, NoError> in
                XCTFail("Failed to get mozscape metrics")
                return SignalProducer.empty
            })
            .map({ $0 as MZMozscapeMetrics? })
        
        let testMetrics = MZMozscapeMetrics.theDistanceMetrics()
        
        expect(metrics.value?.HTTPStatusCode).toEventually(equal(testMetrics.HTTPStatusCode))
        expect(metrics.value?.pageAuthority).toEventually(equal(testMetrics.pageAuthority))
        expect(metrics.value?.domainAuthority).toEventually(equal(testMetrics.domainAuthority))
        expect(metrics.value?.spamScore).toEventually(equal(testMetrics.spamScore))
        expect(metrics.value?.establishedLinksRoot).toEventually(equal(testMetrics.establishedLinksRoot))
        expect(metrics.value?.establishedLinksTotal).toEventually(equal(testMetrics.establishedLinksTotal))
    }
    
    let testDates = MZMozscapeIndexedDates.theDistanceDates()
    
    func testMozscapeDates() {
        
        let dates = MutableProperty<MZMozscapeIndexedDates?>(nil)
        
        dates <~ apiManager.mozscapeIndexedDates()
            .observeOn(UIScheduler())
            .flatMapError({ (error) -> SignalProducer<MZMozscapeIndexedDates?, NoError> in
                XCTFail("Failed to get mozscape metrics")
                return SignalProducer.empty
            })
            .map({ $0 as MZMozscapeIndexedDates? })
        
        let testDates = MZMozscapeIndexedDates.theDistanceDates()
        
        expect(dates.value?.last.timeIntervalSince1970).toEventually(equal(testDates.last.timeIntervalSince1970))
        expect(dates.value?.next?.timeIntervalSince1970).toEventually(equal(testDates.next?.timeIntervalSince1970))
    }
    
}
