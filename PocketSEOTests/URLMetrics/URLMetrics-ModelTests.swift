//
//  URLMetrics-ModelTests.swift
//  MozQuito
//
//  Created by Josh Campion on 04/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest

@testable import PocketSEO

class URLMetrics_ModelTests: XCTestCase {
    
    let urlStore = TestURLStore()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHTMLMetaData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let htmlURL = urlStore.mozscapeMetricsURLForRequest("")!
        
        let testMeta = MZHTMLMetaData.TheDistanceMetaData()
        let returnedMeta = try? MZHTMLMetaData(htmlData: NSData(contentsOfURL: htmlURL)!)
        
        /*
        XCTAssertEqual(returnedMeta?.title,                      testMeta.title,                     "Parsed title incorrectly.")
        XCTAssertEqual(returnedMeta?.titleCharacterCount,        testMeta.titleCharacterCount,       "Parsed title cc incorrectly.")
        XCTAssertEqual(returnedMeta?.description,                testMeta.description,               "Parsed description incorrectly.")
        XCTAssertEqual(returnedMeta?.descriptionCharacterCount,  testMeta.descriptionCharacterCount, "Parsed description cc incorrectly.")
        XCTAssertEqual(returnedMeta?.canonicalURL,               testMeta.canonicalURL,              "Parsed canonicalURL incorrectly.")
        XCTAssertEqual(returnedMeta?.canonicalURLCharacterCount, testMeta.canonicalURLCharacterCount, "Parsed canonicalURLCharacterCount incorrectly.")
        XCTAssertEqual(returnedMeta?.h1Tags,                     testMeta.h1Tags,                    "Parsed h1Tags incorrectly.")
        XCTAssertEqual(returnedMeta?.h1TagsCharacterCount,       testMeta.h1TagsCharacterCount,      "Parsed h1TagsCharacterCount incorrectly.")
        XCTAssertEqual(returnedMeta?.h2Tags,                     testMeta.h2Tags,                    "Parsed h2Tags incorrectly.")
        XCTAssertEqual(returnedMeta?.h2TagsCharacterCount,       testMeta.h2TagsCharacterCount,      "Parsed h2TagsCharacterCount incorrectly.")
 */
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
