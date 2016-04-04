//
//  APIManager.swift
//  MozQuito
//
//  Created by Josh Campion on 04/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import ReactiveCocoa
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON

protocol URLStore {
    
    func mozscapeMetricsURLForRequest(request:String) -> NSURL?
    
    var mozscapeLastIndexedDatesURL:NSURL { get }
    var mozscapeNextIndexedDatesURL:NSURL { get }
}

extension String {
    
    func stringByAddingURLPathEncoding() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())
    }
    
}

struct LiveURLStore:URLStore {
    
    func mozscapeMetricsURLForRequest(request: String) -> NSURL? {
     
        guard let requestURLString = request.stringByAddingURLPathEncoding()
            else { return nil }
        
        return NSURL(string:BaseURL.Mozscape + RequestPath.MozscapeURLMetrics)!.URLByAppendingPathComponent(requestURLString)
    }
    
    let mozscapeLastIndexedDatesURL = NSURL(string: BaseURL.Mozscape + RequestPath.MozscapeIndexedLastDate)!
    let mozscapeNextIndexedDatesURL = NSURL(string: BaseURL.Mozscape + RequestPath.MozscapeIndexedNextDate)!
    
}

class APIManager {
    
    var urlStore:URLStore
    
    init(urlStore:URLStore) {
        self.urlStore = urlStore
    }
    
    func authenticationParameters(existing:[String: AnyObject]) -> [String: AnyObject] {
        
        let token = MZAppDependencies.sharedDependencies().currentAuthenticationToken
        var authenticatedParameters = existing ?? [String:AnyObject]()
        authenticatedParameters["AccessID"] = token.accessId
        authenticatedParameters["Expires"] = "\(token.expiry)"
        authenticatedParameters["Signature"] = token.signature
        
        return authenticatedParameters
    }
    
    func mozscapeURLMetricsForString(requestURLString:String) -> SignalProducer<MZMozscapeMetrics, NSError> {
        return SignalProducer.empty
        
    }
    
    func mozscapeIndexedDates() -> SignalProducer<MZMozscapeIndexedDates, NSError> {
        return SignalProducer.empty
    }
    
    func htmlMetaDataForString(requestURLString:String) -> SignalProducer<MZPageMetaData, NSError> {
        return SignalProducer.empty
    }
    
    func alexaDataForString(requestURLString:String) -> SignalProducer<MZAlexaData, NSError> {
        return SignalProducer.empty
    }
    
    
}
