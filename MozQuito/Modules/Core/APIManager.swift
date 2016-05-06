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
import SwiftyJSON
import TheDistanceCore
import JCLocalization

protocol URLStore {
    
    func mozscapeMetricsURLForRequest(request:String) -> NSURL?
    func mozscapeLinksForRequest(request:String, page:UInt) -> NSURL?
    
    var mozscapeLastIndexedDatesURL:NSURL { get }
    var mozscapeNextIndexedDatesURL:NSURL { get }
    
    var alexaURL:NSURL { get }
}

extension String {
    
    func stringByAddingURLPathEncoding() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())
    }
    
}

extension NSError {
    
    func error429() -> NSError {
        
        let customUserInfo: [NSObject : AnyObject] = [
                NSLocalizedDescriptionKey : LocalizedString(.Error429Text)
            ]
        
        if let errorCode = self.userInfo["NSLocalizedFailureReason"] as? String{
            if errorCode.containsString("429") {
                return NSError(domain: "", code: 429, userInfo: customUserInfo)
            } else {
                return self
            }
        } else {
            return self
        }
    }
}
struct LiveURLStore:URLStore {
    
    func mozscapeMetricsURLForRequest(request: String) -> NSURL? {
        
        return NSURL(string:BaseURL.Mozscape + RequestPath.MozscapeURLMetrics)!.URLByAppendingPathComponent(request)
    }
    
    func mozscapeLinksForRequest(request: String, page:UInt) -> NSURL? {
        
        return NSURL(string: BaseURL.Mozscape + RequestPath.MozscapeLinks)!.URLByAppendingPathComponent(request)
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
    
    // MARK:- Authentication
    
    func authenticationParameters(existing:[String: AnyObject] = [String: AnyObject]()) -> [String: AnyObject] {
        
        let token = MZAppDependencies.sharedDependencies().currentAuthenticationToken
        var authenticatedParameters = existing ?? [String:AnyObject]()
        authenticatedParameters["AccessID"] = token.accessId
        authenticatedParameters["Expires"] = "\(token.expiry)"
        authenticatedParameters["Signature"] = token.signature
        
        return authenticatedParameters
    }
    
    // MARK:- URL Metrics
    
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
            //            .on(next: { (json, _) in
            //                print(json)
            //                }, failed: { (error) in
            //                    print(error)
            //            })
            .map({ $0.1 })
            .flatMapError({ (error) -> SignalProducer<MZMozscapeMetrics, NSError> in
                return SignalProducer(error: error.userFacingError().error429())
            })
    }
    
    
    
    // MARK:- Backlinks
    
    func mozscapeLinksForString(requestURLString:String, requestURLParameters: LinkSearchConfiguration, page:UInt, count:UInt = 25) -> SignalProducer<[MZMozscapeLinks], NSError> {
        
        let cols:[MZLinksKey] = [.Title, .CanonicalURL, .DomainAuthority, .PageAuthority, .SpamScore]
        let colsValue = cols.map({ $0.colValue }).reduce(0, combine: + )
        
        let urlString = urlStore.mozscapeLinksForRequest(requestURLString, page: page)?.absoluteString ?? ""
        
        let parameters =  ["SourceCols":String(colsValue),
                           "LinkCols": String(MZLinksKey.AnchorText.colValue + MZLinksKey.LinkFlags.colValue),
                           "Offset": String(page * count)]
        
        let combinedParameters = parameters + requestURLParameters.mozscapeRequestParameters
        
        return Alamofire.request(.GET, urlString,
            parameters: authenticationParameters(combinedParameters),
            encoding: .URL,
            headers:  nil)
            .validate()
            //            .responseJSON(completionHandler: { (response) in
            //                if case .Failure(let err) = response.result {
            //                    print(err)
            //                }
            //            })
            
            .rac_responseArraySwiftyJSONCreated()
            //            .on(next: { (json, _) in
            //                print(json)
            //                }, failed: { (error) in
            //                    print(error)
            //            })
            .map({ $0.1 })
            .flatMapError({ (error) -> SignalProducer<[MZMozscapeLinks], NSError> in
                return SignalProducer(error: error.userFacingError().error429())
            })
    }
    
    // MARK:- Dates
    
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
                return SignalProducer(error: error.userFacingError().error429())
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
    
    // MARK:- Data
    
    func htmlMetaDataForString(requestURLString:String) -> SignalProducer<MZPageMetaData, NSError> {
        
        if var requestURL = NSURL(string: requestURLString) {
            
            if requestURL.scheme.isEmpty {
                
                if let guessURL = NSURL(string: "http://\(requestURLString)") {
                    requestURL = guessURL
                } else {
                    let inputError = NSError(domain: MZErrorDomain.UserInputError, code: MZErrorCode.InvalidURL, userInfo: [NSLocalizedDescriptionKey: "Invalid URL Entered."])
                    return SignalProducer(error: inputError.userFacingError().error429())
                }
            }
            
            
            return Alamofire.request(.GET, requestURL)
                .validate()
                .rac_responseData()
                .flatMap(.Latest, transform: { (data) -> SignalProducer<MZPageMetaData, NSError> in
                    do {
                        let html = try MZHTMLMetaData(htmlData: data)
                        
                        let pageData = MZPageMetaData(htmlData: html,
                            usingSSL: (requestURL.scheme == "https") ?? false,
                            requestDate: NSDate(),
                            responseURL: requestURL)
                        
                        return SignalProducer(value: pageData)
                        
                    } catch let error {
                        return SignalProducer(error: error as NSError)
                    }
                })
                .flatMapError({ (error) -> SignalProducer<MZPageMetaData, NSError> in
                    return SignalProducer(error: error.userFacingError().error429())
                })
            
        } else {
            return SignalProducer.empty
        }
    }
    
    func alexaDataForString(requestURLString:String) -> SignalProducer<MZAlexaData, NSError> {
        return SignalProducer.empty
    }
    
    
}
