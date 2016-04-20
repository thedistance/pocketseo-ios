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

@testable import PocketSEO

class MozscapeViewModelTests: XCTestCase {

    let viewModel = MozscapeViewModel(apiManager: APIManager(urlStore: TestURLStore()))
    let failingViewModel = MozscapeViewModel(apiManager: APIManager(urlStore: EmptyURLStore()))
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
        
        viewModel.refreshObserver.sendNext("thedistance.co.uk")
        
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
        
    }
    
    func testRefreshRequestAnalytics() {
        
    }
    
    func testNilInput() {
        
    }

    func textInvalidInput() {
        
    }
    
    func testURLErrorMetrics() {
        
    }
    
    func testURLErrorDates() {
        
    }
    
}
