//
//  URLMetricsTest.swift
//  MozQuito
//
//  Created by Josh Campion on 26/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest

@testable import MozQuito

class URLMetricsTest: AdvancedOperationTestCase, ViperTesting {

    override func setUp() {
        super.setUp()
        
        setupDependencies()
    }
    
    func testMozscapeMetricsOperation() {
        
        let urlString = "thedistance.co.uk"
        
        let urlMetricsOperation = MZGetURLMetricsOperation(requestURLString: urlString)
        
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
        
        XCTAssertNotNil(returnedMetrics.title, "Missing Title")
        XCTAssertNotNil(returnedMetrics.canonicalURL, "Missing CanonicalURL")
        XCTAssertNotNil(returnedMetrics.HTTPStatusCode, "Missing HTTPStatusCode")
        XCTAssertNotNil(returnedMetrics.pageAuthority, "Missing PageAuthority")
        XCTAssertNotNil(returnedMetrics.domainAuthority, "Missing DomainAuthority")
        XCTAssertNotNil(returnedMetrics.spamScore, "Missing SpamScore")
        XCTAssertNotNil(returnedMetrics.establishedLinksRoot, "Missing EstablishedLinksRootDomains")
        XCTAssertNotNil(returnedMetrics.establishedLinksTotal, "Missing EstablishedLinksTotalLinks")
    }
}
