//
//  MZMetric.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import TheDistanceCore
import SwiftyJSON

enum MZMetricKey: String {
    case Title = "ut"
    case CanonicalURL = "uu"
    case ExternalEquityLinks = "ueid"
    case MozRankURL = "umrp"
    case MozRankSubdomain = "umbra"
    case HTTPStatusCode = "us"
    case PageAuthority = "upa"
    case DomainAuthority = "pda"
    case SpamScore = "fspsc"
    case TimeLastCrawled = "ulc"
    case EstablishedLinksRootDomains = "uifq"
    case EstablishedLinksTotalLinks = "uid"
    
    var colValue:UInt64 {
        switch (self) {
        case .Title:
            return 1
        case .CanonicalURL:
            return 4
        case .ExternalEquityLinks:
            return 32
        case .MozRankURL:
            return 16384
        case .MozRankSubdomain:
            return 32768
        case .HTTPStatusCode:
            return 536870912
        case .PageAuthority:
            return 34359738368
        case .DomainAuthority:
            return 68719476736
        case .SpamScore:
            return 67108864
        case .TimeLastCrawled: 
            return 144115188075855872
        case .EstablishedLinksRootDomains: 
            return 512
        case .EstablishedLinksTotalLinks: 
            return 2048
        }
    }
    
}

struct MZMozscapeMetrics {
    
    let title:String?
    let canonicalURL:NSURL?
    let HTTPStatusCode:Int?
    
    let pageAuthority:Double?
    let pageAuthorityTotal:Int = 100
    
    let domainAuthority:Double?
    let domainAuthorityTotal:Int = 100
    
    let spamScore:Double?
    let spamScoreTotal:Int = 17
    
    let establishedLinksRoot:Int?
    let establishedLinksTotal:Int?
    
    init(json:JSON) throws {
        
        if let results = json.dictionary {
            
            let keyResults:[MZMetricKey:JSON] = Dictionary(results.flatMap({ (str:String, value:JSON) -> (MZMetricKey, JSON)? in
                
                if let key = MZMetricKey(rawValue: str) {
                    return (key, value)
                } else {
                    return nil
                }
            }))

//            if {
             let title = keyResults[.Title]?.string
                let canURL = keyResults[.CanonicalURL]?.URL
                let http = keyResults[.HTTPStatusCode]?.int
                let pageAuth = keyResults[.PageAuthority]?.double
                let domainAuth = keyResults[.DomainAuthority]?.double
                let spam = keyResults[.SpamScore]?.double
                let root = keyResults[.EstablishedLinksRootDomains]?.int
                let total = keyResults[.EstablishedLinksTotalLinks]?.int
                    
                    self.title = title
                    self.canonicalURL = canURL
            self.HTTPStatusCode = http
                    self.pageAuthority = pageAuth
                    self.domainAuthority = domainAuth
                    self.spamScore = spam
                    self.establishedLinksRoot = root
                    self.establishedLinksTotal = total
                    
                    
//            } else {
//                throw NSError(InitUnexpectedResponseWithDescription: "unknown url-metrics response. Missing parameters.Got\n\(results)")
//            }
            
            
        } else {
            
            throw NSError(domain: .MozscapeError, code: .UnexpectedResponse, userInfo: [NSLocalizedDescriptionKey: "url-metrics response json in unexpected format. Expected Dictionary. Got\n\(json)"])
            
        }
        
    }
}

struct MZMozscapeIndexedDates {
    
    let last:NSDate
    let next:NSDate?
    
    init(json:JSON) throws {
        
        if let lastUnixDate = json["last_update"].double {
            
            last = NSDate(timeIntervalSince1970: lastUnixDate)
            
            if let nextUnixDate = json["last_update"].double {
                next = NSDate(timeIntervalSince1970: nextUnixDate)
            } else {
                next = nil
            }
            
        } else {
            throw NSError(InitUnexpectedResponseWithDescription: "Failed to create \(self.dynamicType). last_update not found in json: \(json)")
        }
    }
}

/*

enum MZMetricValueType: Equatable {
case ValueAbsolute(Double)
case ValueOutOf(Double, Double)
case StringMetric(String)
case DateMetric(NSDate)
}

func ==(v1:MZMetricValueType, v2:MZMetricValueType) -> Bool {

switch (v1, v2) {
case (.ValueAbsolute(let a1), .ValueAbsolute(let a2)):
return a1 == a2
case (.ValueOutOf(let a1, let t1), .ValueOutOf(let a2, let t2)):
return a1 == a2 && t1 == t2
case (.StringMetric(let a1), .StringMetric(let a2)):
return a1 == a2
case (.DateMetric(let a1), .DateMetric(let a2)):
return a1 == a2
default:
return false
}
}


struct MZMetric {

    let key:MZMetricKey
    let value:MZMetricValueType

    init(key:MZMetricKey, value:MZMetricValueType) {
        self.key = key
        self.value = value
    }
    
    init?(keyString:String, value:JSON) throws {
        
        if let key = MZMetricKey(rawValue: keyString) {
            
            let metricValue:MZMetricValueType
            
            switch (key) {
            case .Title, .CanonicalURL:
                
                if let str = value.string {
                    metricValue = .StringMetric(str)
                } else {
                    throw NSError(InitUnexpectedResponseWithDescription: "expected String with \"\(key)\", got: \(value)")
                }
                
            case .ExternalEquityLinks:
                
                if let count = value.double {
                    metricValue = .ValueAbsolute(count)
                } else {
                    throw NSError(InitUnexpectedResponseWithDescription: "expected Number with \"\(key)\", got: \(value)")
                }
                
            case .MozRankURL:
                <#statement#>
            case .MozRankSubdomain:
                <#statement#>
            case .HTTPStatusCode:
                <#statement#>
            case .PageAuthority:
                <#statement#>
            case .DomainAuthroirty:
                <#statement#>
            case .SpamScore: 
                <#statement#>
            case .TimeLastCrawled: 
                <#statement#>
            case .EstablishedLinksRootDomains: 
                <#statement#>
            case .EstablishedLinksTotalLinks:
                <#statement#>
            }
            
        } else {
        
            throw NSError(InitUnexpectedResponseWithDescription: "Unknown metric \"\(keyString)\" with value: \(value)")

        }
        
    }
}
*/