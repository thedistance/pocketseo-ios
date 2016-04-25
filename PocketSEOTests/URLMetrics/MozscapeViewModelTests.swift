//
//  MozscapeViewModelTests.swift
//  MozQuito
//
//  Created by Josh Campion on 04/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest

import ReactiveCocoa
import Result
import Nimble
import Components

@testable import PocketSEO

class MozscapeViewModelTests: XCTestCase {

    let viewModel = MozscapeViewModel(apiManager: APIManager(urlStore: TestURLStore()))
    let failingViewModel = MozscapeViewModel(apiManager: APIManager(urlStore: EmptyURLStore()))
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        MZAppDependencies.sharedDependencies().analyticsReporter = TestAnalyticsInteractor()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSimpleSuccess() {
        
        let info = MutableProperty<MozscapeInfo?>(nil)
        
        info <~ viewModel.contentChangesSignal.map({ $0 as MozscapeInfo? })
        
        let testMetrics = MZMozscapeMetrics.theDistanceMetrics()
        let testDates = MZMozscapeIndexedDates.theDistanceDates()
        
        viewModel.urlString.value = "thedistance.co.uk"
        
        expect(info.value?.metrics.HTTPStatusCode).toEventually(equal(testMetrics.HTTPStatusCode))
        expect(info.value?.metrics.pageAuthority).toEventually(equal(testMetrics.pageAuthority))
        expect(info.value?.metrics.domainAuthority).toEventually(equal(testMetrics.domainAuthority))
        expect(info.value?.metrics.spamScore).toEventually(equal(testMetrics.spamScore))
        expect(info.value?.metrics.establishedLinksRoot).toEventually(equal(testMetrics.establishedLinksRoot))
        expect(info.value?.metrics.establishedLinksTotal).toEventually(equal(testMetrics.establishedLinksTotal))
        
        expect(info.value?.dates?.last.timeIntervalSince1970).toEventually(equal(testDates.last.timeIntervalSince1970))
        expect(info.value?.dates?.next?.timeIntervalSince1970).toEventually(equal(testDates.next?.timeIntervalSince1970))
    }
    
    func testNewRequestAnalytics() {
        
        guard let analytics = MZAppDependencies.sharedDependencies().analyticsReporter as? TestAnalyticsInteractor else {
            XCTFail("No reporter found")
            return
        }
        
        viewModel.urlString.value = "thedistance.co.uk"
        
        //analytics.sendAnalytic(AnalyticEvent(category: .DataRequest, action: .loadUrl, label: "thedistance.co.uk"))
        
        let expectedEvent = AnalyticEvent(category: .DataRequest, action: .loadUrl, label: "thedistance.co.uk")
        expect(analytics.trackedEvents).toEventually(equal([expectedEvent]))
    }
    
    func testRefreshRequestAnalytics() {
        
        guard let analytics = MZAppDependencies.sharedDependencies().analyticsReporter as? TestAnalyticsInteractor else {
            XCTFail("No reporter found")
            return
        }
        viewModel.urlString.value = "thedistance.co.uk"
        viewModel.urlString.value = "thedistance.co.uk"
        
        let expectedRequest = AnalyticEvent(category: .DataRequest, action: .loadUrl, label: "thedistance.co.uk")
        let expectedRefresh = AnalyticEvent(category: .DataRequest, action: .refreshData, label: "thedistance.co.uk")
        expect(analytics.trackedEvents).toEventually(equal([expectedRequest, expectedRefresh]))

        
    }
    
}
