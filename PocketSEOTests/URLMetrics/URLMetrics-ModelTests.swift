//
//  URLMetrics-ModelTests.swift
//  MozQuito
//
//  Created by Josh Campion on 04/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest
import Nimble
import SwiftyJSON
import Components

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
    
    func testMozscapeMetaData() {
        
        let jsonData = NSData(contentsOfURL: urlStore.mozscapeMetricsURLForRequest("")!)!
        let returnedMetrics = try? MZMozscapeMetrics(json: JSON(data: jsonData))
        let testMetrics = MZMozscapeMetrics.theDistanceMetrics()
        expect(returnedMetrics?.HTTPStatusCode).to(equal(testMetrics.HTTPStatusCode))
        expect(returnedMetrics?.pageAuthority).to(equal(testMetrics.pageAuthority))
        expect(returnedMetrics?.domainAuthority).to(equal(testMetrics.domainAuthority))
        expect(returnedMetrics?.spamScore).to(equal(testMetrics.spamScore))
        expect(returnedMetrics?.establishedLinksRoot).to(equal(testMetrics.establishedLinksRoot))
        expect(returnedMetrics?.establishedLinksTotal).to(equal(testMetrics.establishedLinksTotal))
    }
    
    func testHTMLMetaData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let htmlURL = testBundle.URLForResource("thedistance", withExtension: "html")!
        
        let testMeta = MZHTMLMetaData.TheDistanceMetaData()
        let returnedMeta = try? MZHTMLMetaData(htmlData: NSData(contentsOfURL: htmlURL)!)
        
        expect(returnedMeta?.title).to(equal(testMeta.title))
        expect(returnedMeta?.titleCharacterCount).to(equal(testMeta.titleCharacterCount))
        expect(returnedMeta?.description).to(equal(testMeta.description))
        expect(returnedMeta?.descriptionCharacterCount).to(equal(testMeta.descriptionCharacterCount))
        expect(returnedMeta?.canonicalURL).to(equal(testMeta.canonicalURL))
        expect(returnedMeta?.canonicalURLCharacterCount).to(equal(testMeta.canonicalURLCharacterCount))
        expect(returnedMeta?.h1Tags).to(equal(testMeta.h1Tags))
        expect(returnedMeta?.h1TagsCharacterCount).to(equal(testMeta.h1TagsCharacterCount))
        expect(returnedMeta?.h2Tags).to(equal(testMeta.h2Tags))
        expect(returnedMeta?.h2TagsCharacterCount).to(equal(testMeta.h2TagsCharacterCount))
    }
    
//    func testAlexaData() {
//        
//        let alexaData = NSData(contentsOfURL: urlStore.alexaURL)!
//        
//        let returnedAlexa = try? MZAlexaData(xmlData: alexaData)
//        let testAlexa = MZAlexaData.TheDistanceAlexaData()
//        
//        expect(returnedAlexa?.popularityText).to(equal(testAlexa.popularityText))
//        expect(returnedAlexa?.reachRank).to(equal(testAlexa.reachRank))
//        expect(returnedAlexa?.rankDelta).to(equal(testAlexa.rankDelta))
//    }
    
}
