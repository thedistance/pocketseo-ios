//
//  Links-ModelTests.swift
//  MozQuito
//
//  Created by Ashhad Syed on 05/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest
import Nimble
import SwiftyJSON

@testable import PocketSEO

class Links_ModelTests: XCTestCase {
    
    let urlStore = TestURLStore()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMozscapeLinkData() {
        
        let jsonData = NSData(contentsOfURL: urlStore.mozscapeLinksForRequest("")!)!
        let returnedLinks = try? MZMozscapeLinks(json: JSON(data: jsonData))
        let testLinks = MZMozscapeLinks.theDistanceLinks()
        
        expect(returnedLinks?.title).to(equal(testLinks.title))
        expect(returnedLinks?.canonicalURL).to(equal(testLinks.canonicalURL))
        expect(returnedLinks?.domainAuthority).to(equal(testLinks.domainAuthority))
        expect(returnedLinks?.pageAuthority).to(equal(testLinks.pageAuthority))
        expect(returnedLinks?.spamScore).to(equal(testLinks.spamScore))
        expect(returnedLinks?.anchorText).to(equal(testLinks.anchorText))
        
    }
}
