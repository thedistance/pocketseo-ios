//
//  URLMetrics_NoNetwork_Tests.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest
@testable import PocketSEO

extension MZAlexaData {
    
    static func TheDistanceAlexaData() -> MZAlexaData {
        return MZAlexaData(popularityText: "1316283", reachRank: "1199410", rankDelta: "+29419")
    }
    
}

class URLMetrics_NoNetwork_Tests: AdvancedOperationTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseHTMLOpeartion() {
        
        guard let testHTMLURL = NSBundle(forClass: self.dynamicType).URLForResource("thedistance", withExtension: "html"),
            let testData = NSData(contentsOfURL: testHTMLURL) else {
            
                XCTFail("Unable to load test html")
                return
        }
        
        let parseOperation = MZParseHTMLDataOperation(data: testData)
        
        var meta:MZHTMLMetaData? = nil
        
        parseOperation.success = { (responseMeta) in
            meta = responseMeta
        }
        
        registerAndRunOperation(parseOperation, named: __FUNCTION__) { (operation, errors) -> () in
            XCTAssertEqual(errors.count, 0, "Failed to parse test html: \(errors)")
        }
        
        guard let returnedMeta = meta else {
            XCTFail("Failed to parse page meta data")
            return
        }
        
        let testMeta = MZHTMLMetaData.TheDistanceMetaData()
        
        XCTAssertEqual(returnedMeta.title,                      testMeta.title,                     "Parsed title incorrectly.")
        XCTAssertEqual(returnedMeta.titleCharacterCount,        testMeta.titleCharacterCount,       "Parsed title cc incorrectly.")
        XCTAssertEqual(returnedMeta.description,                testMeta.description,               "Parsed description incorrectly.")
        XCTAssertEqual(returnedMeta.descriptionCharacterCount,  testMeta.descriptionCharacterCount, "Parsed description cc incorrectly.")
        XCTAssertEqual(returnedMeta.canonicalURL,               testMeta.canonicalURL,              "Parsed canonicalURL incorrectly.")
        XCTAssertEqual(returnedMeta.canonicalURLCharacterCount, testMeta.canonicalURLCharacterCount, "Parsed canonicalURLCharacterCount incorrectly.")
        XCTAssertEqual(returnedMeta.h1Tags,                     testMeta.h1Tags,                    "Parsed h1Tags incorrectly.")
        XCTAssertEqual(returnedMeta.h1TagsCharacterCount,       testMeta.h1TagsCharacterCount,      "Parsed h1TagsCharacterCount incorrectly.")
        XCTAssertEqual(returnedMeta.h2Tags,                     testMeta.h2Tags,                    "Parsed h2Tags incorrectly.")
        XCTAssertEqual(returnedMeta.h2TagsCharacterCount,       testMeta.h2TagsCharacterCount,      "Parsed h2TagsCharacterCount incorrectly.")
        
    }
    
    func testParseAlexaData() {
        
        guard let testXMLURL = NSBundle(forClass: self.dynamicType).URLForResource("thedistance-alexa", withExtension: "xml"),let testData = NSData(contentsOfURL: testXMLURL) else {
            
            XCTFail("Unable to load test html")
            return
        }
        
        let parseOperation = MZParseAlexaDataOperation(data: testData)

        var alexa:MZAlexaData? = nil
        
        parseOperation.success = { (response) in
            alexa = response
        }
        
        registerAndRunOperation(parseOperation, named: __FUNCTION__) { (operation, errors) -> () in
            XCTAssertEqual(errors.count, 0, "Failed to parse test xml: \(errors)")
        }
        
        guard let returnedAlexa = alexa else {
            XCTFail("No alexa data returned")
            return
        }

        let testAlexa = MZAlexaData.TheDistanceAlexaData()
        
        XCTAssertEqual(returnedAlexa.popularityText, testAlexa.popularityText, "Parsed popularity text incorrectly")
        XCTAssertEqual(returnedAlexa.reachRank, testAlexa.reachRank, "Parsed reach rank text incorrectly")
        XCTAssertEqual(returnedAlexa.rankDelta, testAlexa.rankDelta, "Parsed rank delta text incorrectly")
        
    }
}
