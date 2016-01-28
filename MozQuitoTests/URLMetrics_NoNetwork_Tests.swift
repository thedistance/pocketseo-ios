//
//  URLMetrics_NoNetwork_Tests.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest
@testable import MozQuito

extension MZHTMLMetaData {
    
    static func TheDistanceMetaData() -> MZHTMLMetaData {
        return MZHTMLMetaData(title: "App Developers UK | Mobile App Development | The Distance, York",
            canonicalURL: NSURL(string: "https://thedistance.co.uk/")!,
            description: "We are award winning UK app developers UK who develop mobile app development solutions for IOS & Android for B2C, B2B & Enterprise. Call York team today.",
            h1Tags: ["The Yorkshire & UK leading mobile app developers"],
            h2Tags: ["Mobile App Consultancy",
                "Mobile App Development",
                "Mobile App UI/UX",
                "Trusted By",
                "OUR TOOLS",
                "PLATFORMS",
                "TELL US YOUR APP IDEA"])

    }
}

extension MZPageMetaData {
    
    static func TheDistanceMetaData() -> MZPageMetaData {
        
        return MZPageMetaData(htmlData: MZHTMLMetaData.TheDistanceMetaData(),
            usingSSL: true,
            requestDate: NSDate())
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
}
