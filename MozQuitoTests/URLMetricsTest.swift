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
    
    func testURLMetricsOperationString() {
        
        let urlString = "thedistance.co.uk"
        
        let urlMetricsOperatoin = MZGetURLMetricsOperation(requestURLString: urlString)
        
        
    }
}
