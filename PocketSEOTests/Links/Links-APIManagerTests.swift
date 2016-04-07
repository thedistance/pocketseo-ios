//
//  URLMetrics-APIManager.swift
//  MozQuito
//
//  Created by Ashhad Syed on 05/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import XCTest

import ReactiveCocoa
import Result
import Nimble
import SwiftyJSON
import Components

@testable import PocketSEO


public func contentEqual<T: ContentEquatable>(expectedValue: T?) -> NonNilMatcherFunc<T> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "equal <\(expectedValue)>"
        let actualValue = try actualExpression.evaluate()
        
        if let expected = expectedValue,
            actual = actualValue {
            return actual.contentMatches(expected)
        } else {
            if expectedValue == nil {
                failureMessage.postfixActual = " (use beNil() to match nils)"
            }
            return false
        }
    }
}


class Links_APIManager: XCTestCase {
    
    let apiManager = APIManager(urlStore: TestURLStore())
    let emptyAPIManager = APIManager(urlStore: EmptyURLStore())
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMozscapeLinksPage0() {
        let links = MutableProperty<[MZMozscapeLinks]?>(nil)
        
        links <~ apiManager.mozscapeLinksForString("thedistance.co.uk", page: 0)
            .observeOn(UIScheduler())
            .flatMapError({ (error) -> SignalProducer<[MZMozscapeLinks], NoError> in
                XCTFail("Failed to get mozscape links")
                return SignalProducer.empty
            })
            .map({ $0 as [MZMozscapeLinks]? })
        
        let testLinks = MZMozscapeLinks.theDistanceLinks()
        
        expect(links.value?.count).toEventually(equal(25))
        expect(links.value?[2]).toEventually(contentEqual(testLinks))
        
//        expect(links.value?.title).toEventually(equal(testLinks.title))
//        expect(links.value?.canonicalURL).toEventually(equal(testLinks.canonicalURL))
//        expect(links.value?.domainAuthority).toEventually(equal(testLinks.domainAuthority))
//        expect(links.value?.pageAuthority).toEventually(equal(testLinks.pageAuthority))
//        expect(links.value?.spamScore).toEventually(equal(testLinks.spamScore))
//        expect(links.value?.anchorText).toEventually(equal(testLinks.anchorText))
    }
    
    // test the page is observed
    func testMozscapeLinksPage1() {
        
        let found = MutableProperty<[MZMozscapeLinks]?>(nil)
        
        found <~ apiManager.mozscapeLinksForString("thedistance.co.uk", page: 1)
            .observeOn(UIScheduler())
            .flatMapError({ (error) -> SignalProducer<[MZMozscapeLinks], NoError> in
                XCTFail("Failed to get mozscape metrics")
                return SignalProducer.empty
            })
            .map { $0 as [MZMozscapeLinks]? }
        
        let expected = MZMozscapeLinks.theDistanceLinks1()
        
        expect(found.value?.count).toEventually(equal(10))
        expect(found.value?[1]).toEventually(contentEqual(expected))
    }
}
