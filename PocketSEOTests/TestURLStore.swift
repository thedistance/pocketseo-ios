//
//  TestURLStore.swift
//  MozQuito
//
//  Created by Josh Campion on 04/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

@testable import PocketSEO

let testBundle = NSBundle(forClass: TestURLStore.self)

class TestURLStore:NSObject, URLStore {
 
    func mozscapeMetricsURLForRequest(request: String) -> NSURL? {
        return testBundle.URLForResource("MozscapeMetrics", withExtension: "json")
    }
    
    func mozscapeLinksForRequest(request: String, page:UInt) -> NSURL? {
        return testBundle.URLForResource("MozscapeLinks-\(page)", withExtension: "json")
    }
    
    func mozscapeLinksForRequestOrderedByDA(request: String, page: UInt) -> NSURL? {
        return testBundle.URLForResource("MozscapeLinksOrderedByDA", withExtension: "json")
    }
    
    let mozscapeLastIndexedDatesURL = NSURL(string: BaseURL.Mozscape + RequestPath.MozscapeIndexedLastDate)!
    let mozscapeNextIndexedDatesURL = NSURL(string: BaseURL.Mozscape + RequestPath.MozscapeIndexedNextDate)!
    
    let alexaURL = testBundle.URLForResource("thedistance-alexa", withExtension: "xml")!
    
    func backlinksURLForRequest(request:String, page:UInt) -> NSURL? {
        return nil
    }
}

class EmptyURLStore:NSObject, URLStore {
    
    func mozscapeMetricsURLForRequest(request: String) -> NSURL? {
        return NSURL()
    }
    
    func mozscapeLinksForRequest(request: String, page:UInt) -> NSURL? {
        return NSURL()
    }
    
    let mozscapeLastIndexedDatesURL = NSURL()
    let mozscapeNextIndexedDatesURL = NSURL()
    
    let alexaURL = NSURL()
}