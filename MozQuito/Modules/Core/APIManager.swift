//
//  APIManager.swift
//  MozQuito
//
//  Created by Josh Campion on 04/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import Alamofire
import ReactiveCocoa
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON
import TheDistanceCore

protocol URLStore {
    
    func mozscapeMetricsURLForRequest(request:String) -> NSURL?
    
    var mozscapeLastIndexedDatesURL:NSURL { get }
    var mozscapeNextIndexedDatesURL:NSURL { get }
    
    var alexaURL:NSURL { get }
    
    func backlinksURLForRequest(request:String, page:UInt) -> NSURL?
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
    
    let alexaURL = NSURL(string: BaseURL.Alexa.URLString)!
    
    func backlinksURLForRequest(request:String, page:UInt) -> NSURL? {
        return nil
    }
}

class APIManager {
    
    var urlStore:URLStore
    
    init(urlStore:URLStore) {
        self.urlStore = urlStore
    }
    
    func authenticationParameters(existing:[String: AnyObject] = [String: AnyObject]()) -> [String: AnyObject] {
        
        let token = MZAppDependencies.sharedDependencies().currentAuthenticationToken
        var authenticatedParameters = existing ?? [String:AnyObject]()
        authenticatedParameters["AccessID"] = token.accessId
        authenticatedParameters["Expires"] = "\(token.expiry)"
        authenticatedParameters["Signature"] = token.signature
        
        return authenticatedParameters
    }
    
    func linksForString(requestURLString:String, page:UInt, count:UInt = 25) -> SignalProducer<[BackLink], NSError> {
        
        let cols:[MZMetricKey] = [.Title, .CanonicalURL, .HTTPStatusCode, .DomainAuthority, .PageAuthority, .SpamScore, .EstablishedLinksRootDomains, .EstablishedLinksTotalLinks]
        let colsValue = cols.map({ $0.colValue }).reduce(0, combine: + )
        
        
        let urlString = urlStore.mozscapeMetricsURLForRequest(requestURLString)?.absoluteString ?? ""
        
        return Alamofire.request(.GET, urlString,
            parameters: authenticationParameters(["Cols": "\(colsValue)", "Limit": count, "Page": page]),
            encoding: .URL,
            headers: nil)
            .validate()
            .rac_responseArraySwiftyJSONCreated()
            .map({ $0.1 })
            .flatMapError({ (error) -> SignalProducer<[BackLink], NSError> in
                return SignalProducer(error: error.userFacingError())
            })
    }

    
    func mozscapeURLMetricsForString(requestURLString:String) -> SignalProducer<MZMozscapeMetrics, NSError> {
        
        let cols:[MZMetricKey] = [.Title, .CanonicalURL, .HTTPStatusCode, .DomainAuthority, .PageAuthority, .SpamScore, .EstablishedLinksRootDomains, .EstablishedLinksTotalLinks]
        let colsValue = cols.map({ $0.colValue }).reduce(0, combine: + )
        
    
        let urlString = urlStore.mozscapeMetricsURLForRequest(requestURLString)?.absoluteString ?? ""
        
        return Alamofire.request(.GET, urlString,
                                         parameters: authenticationParameters(["Cols": String(colsValue)]),
                                         encoding: .URL,
                                         headers: nil)
            .validate()
            .rac_responseSwiftyJSONCreated()
            .map({ $0.1 })
            .flatMapError({ (error) -> SignalProducer<MZMozscapeMetrics, NSError> in
                return SignalProducer(error: error.userFacingError())
            })
    }
    
    func dateProducer(url:NSURL, jsonKey:String) -> SignalProducer<NSDate?, NSError> {
        
        return Alamofire.request(.GET, url,
            parameters: authenticationParameters(),
            encoding: .URL,
            headers: nil)
            .validate()
            .rac_responseSwiftyJSON()
            .map { (json) -> NSDate? in
                
                if let seconds = json[jsonKey].double {
                    return NSDate(timeIntervalSince1970: seconds)
                } else {
                    return nil
                }
            }.flatMapError({ (error) -> SignalProducer<NSDate?, NSError> in
                return SignalProducer(error: error.userFacingError())
            })

    }
    
    func mozscapeIndexedDates() -> SignalProducer<MZMozscapeIndexedDates?, NSError> {
        
        let lastProducer = dateProducer(urlStore.mozscapeLastIndexedDatesURL, jsonKey: "last_update")
        let nextProducer = dateProducer(urlStore.mozscapeNextIndexedDatesURL, jsonKey: "next_update")
        
        let bothDatesProducer = combineLatest(lastProducer, nextProducer).map { (last, next) -> MZMozscapeIndexedDates? in
            
            if let lastDate = last {
                return MZMozscapeIndexedDates(last: lastDate, next: next)
            } else {
                return nil
            }
        }
        
        return bothDatesProducer
    }
    
    func htmlMetaDataForString(requestURLString:String) -> SignalProducer<MZPageMetaData, NSError> {
        return SignalProducer.empty
    }
    
    func alexaDataForString(requestURLString:String) -> SignalProducer<MZAlexaData, NSError> {
        return SignalProducer.empty
    }
    
    
}
