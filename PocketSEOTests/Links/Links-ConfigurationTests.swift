//
//  Links-ConfigurationTests.swift
//  MozQuito
//
//  Created by Ashhad Syed on 08/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import SwiftyJSON

@testable import PocketSEO

class Links_ConfigurationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMozscapeLinkDefaultConfiguration() {

        let defaultParameters = LinkSearchConfiguration.defaultConfiguration()
        
        expect(defaultParameters.sortBy).to(equal(LinkSortBy.PageAuthority))
        expect(defaultParameters.target).to(equal(LinkTarget.Page))
        expect(defaultParameters.source).to(equal(LinkSource.All))
        expect(defaultParameters.type).to(equal(LinkType.All))
    }
    
    func testMozscapeLinkRequestParamsConfiguration() {
        
        let requestParams = LinkSearchConfiguration.init(sortBy: .DomainAuthority, target: .Page, source: .All, type: .All, targetCols: "4", limit: "25").mozscapeRequestParameters
 
        let expectedParams = LinkSearchConfiguration.distanceLinkSortyByDA().mozscapeRequestParameters
        
        expect(requestParams).to(equal(expectedParams))

    }
    
    func testMozscapeLinkRequestParamsNoSourceAndTypeConfiguration() {
        
        let requestParams = LinkSearchConfiguration.init(sortBy: .PageAuthority, target: .Page, source: .External, type: .All, targetCols: "4", limit: "25").mozscapeRequestParameters
        
        let expectedParams = LinkSearchConfiguration.distanceLinkFilterByTypeAndSource().mozscapeRequestParameters
        
        expect(requestParams).to(equal(expectedParams))
    }
}
