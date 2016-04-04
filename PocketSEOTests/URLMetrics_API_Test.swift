//
//  URLMetricsTest.swift
//  MozQuito
//
//  Created by Josh Campion on 26/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest
@testable import PocketSEO

class URLMetrics_API_Test: AdvancedOperationTestCase, ViperTesting {

    override func setUp() {
        super.setUp()
        
        setupDependencies()
    }
    
    func testMozscapeMetricsOperation() {
        
        let urlString = "thedistance.co.uk"
        
        let urlMetricsOperation = MZGetMozscapeURLMetricsOperation(requestURLString: urlString)
        
        var metrics:MZMozscapeMetrics? = nil
        
        urlMetricsOperation.success = { (results) in
            metrics = results
        }
        
        registerAndRunOperation(urlMetricsOperation, named: __FUNCTION__) { (operation, errors) -> () in
            XCTAssertEqual(errors.count, 0, "Operation Failed: \(errors)")
        }
        
        guard let returnedMetrics = metrics else {
            XCTFail("Failed to return any metrics")
            return
        }
        
        XCTAssertNotNil(returnedMetrics.HTTPStatusCode, "Missing HTTPStatusCode")
        XCTAssertNotNil(returnedMetrics.pageAuthority, "Missing PageAuthority")
        XCTAssertNotNil(returnedMetrics.domainAuthority, "Missing DomainAuthority")
        XCTAssertNotNil(returnedMetrics.spamScore, "Missing SpamScore")
        XCTAssertNotNil(returnedMetrics.establishedLinksRoot, "Missing EstablishedLinksRootDomains")
        XCTAssertNotNil(returnedMetrics.establishedLinksTotal, "Missing EstablishedLinksTotalLinks")
    }
    
    func testMozscapeIndexedDatesOperation() {
        
        let datesOperation = MZGetMozscapeIndexDatesOperation()
        
        var dates:MZMozscapeIndexedDates? = nil
        
        datesOperation.success = { (responseDates) in
            dates = responseDates
        }
        
        registerAndRunOperation(datesOperation, named: __FUNCTION__) { (operation, errors) -> () in
            XCTAssertEqual(errors.count, 0, "Errors when getting Indexed Dates: \(errors)")
        }
        
        guard let returnedDates = dates else {
            XCTFail("Failed to get Indexed Dates")
            return
        }
        
        let now = NSDate()
        let lastComparison = now.compare(returnedDates.last)
        
        XCTAssert(lastComparison == .OrderedDescending, "Last Indexed Date is in the future...")
        // XCTAssertNotNil(returnedDates.next, "No Next Indexed Date found.")
    }
    
    func testPageMetaDataOperation() {
        
        let metaDataOperation = MZGetPageMetaDataOperation(url: NSURL(string: "http://thedistance.co.uk")!)
        
        var meta:MZPageMetaData? = nil
        
        metaDataOperation.success = { (responseMeta) in
            meta = responseMeta
        }
        
        registerAndRunOperation(metaDataOperation, named: __FUNCTION__) { (operation, errors) -> () in
            XCTAssertEqual(errors.count, 0, "Getting page meta data failed: \(errors)")
        }
        
        guard let returnedMeta = meta else {
            XCTFail("No meta data returned")
            return
        }
        
        XCTAssertNotNil(returnedMeta.htmlMetaData.title, "No title returned")
        XCTAssertNotNil(returnedMeta.htmlMetaData.description, "No description returned")
        XCTAssertNotNil(returnedMeta.htmlMetaData.canonicalURL, "No canonical url returned")
        XCTAssertNotNil(returnedMeta.htmlMetaData.h1Tags, "No h1 tags returned")
        XCTAssertNotNil(returnedMeta.htmlMetaData.h2Tags, "No h2 tags returned")
        XCTAssert(returnedMeta.usingSSL, "SSL not being used")
    }
    
    func testAlexaData() {
        
        
        let alexaOperation = MZGetAlexaDataOperation(urlString: "thedistance.co.uk")
        
        var data:MZAlexaData? = nil
        
        alexaOperation.success = { (response) in
            data = response
        }
        
        registerAndRunOperation(alexaOperation,
            named: __FUNCTION__) { (operation, errors) -> () in
                XCTAssertEqual(errors.count, 0, "Getting alexa data failed: \(errors)")
        }
        
        guard let returnedAlexa = data else {
            XCTFail("No alexa data returned")
            return
        }
        
        XCTAssertNotNil(returnedAlexa.popularityText, "Missing popularity text")
        XCTAssertNotNil(returnedAlexa.reachRank, "Missing reach rank text")
        XCTAssertNotNil(returnedAlexa.rankDelta, "Missing rank delta text")
    }
}
