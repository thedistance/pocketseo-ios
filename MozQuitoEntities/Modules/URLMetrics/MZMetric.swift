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

public enum MZMetricKey: String {
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
    
    public var colValue:UInt64 {
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

public struct MZMozscapeMetrics {
    
    init() throws {
        let jsonInfo = [
            "flan" : "en",
            "fsplc" : 1413952826,
            "pda" : 33.6962235544803,
            "ut" : "",
            "us" : 301,
            "uu" : "thedistance.co.uk/",
            "fsps" : 200,
            "uid" : 793,
            "fspf" : 0,
            "fspsc" : 1,
            "upa" : 41.97760739323027,
            "uifq" : 107,
            "fspp" : "http://thedistance.co.uk/ http://thedistance.co.uk/what-we-do/ecommerce/ http://thedistance.co.uk/services/ecommerce http://thedistance.co.uk/who-we-are/the-team/anthony-main http://thedistance.co.uk/anthony-main/"
        ]
        
        try self.init(json: JSON(jsonInfo))
    }
    
    public let title:String?
    public let canonicalURL:NSURL?
    public let HTTPStatusCode:Int?
    
    public let pageAuthority:Double?
    public let pageAuthorityTotal:Int = 100
    
    public let domainAuthority:Double?
    public let domainAuthorityTotal:Int = 100
    
    public let spamScore:Double?
    public let spamScoreTotal:Int = 17
    
    public let establishedLinksRoot:Int?
    public let establishedLinksTotal:Int?
    
    public init(json:JSON) throws {
        
        if let results = json.dictionary {
            
            let keyResults:[MZMetricKey:JSON] = Dictionary(results.flatMap({ (str:String, value:JSON) -> (MZMetricKey, JSON)? in
                
                if let key = MZMetricKey(rawValue: str) {
                    return (key, value)
                } else {
                    return nil
                }
            }))

            let title = keyResults[.Title]?.string
            let canURL = keyResults[.CanonicalURL]?.URL
            let http = keyResults[.HTTPStatusCode]?.int
            let pageAuth = keyResults[.PageAuthority]?.double
            let domainAuth = keyResults[.DomainAuthority]?.double
 
            let root = keyResults[.EstablishedLinksRootDomains]?.int
            let total = keyResults[.EstablishedLinksTotalLinks]?.int
            
            self.title = title
            self.canonicalURL = canURL
            self.HTTPStatusCode = http
            self.pageAuthority = pageAuth
            self.domainAuthority = domainAuth
            
            if let s = keyResults[.SpamScore]?.double where s > 0 {
                self.spamScore = s - 1.0
            } else {
                self.spamScore = nil
            }
            
            self.establishedLinksRoot = root
            self.establishedLinksTotal = total
            
        } else {
            
            throw NSError(domain: .MozscapeError, code: .UnexpectedResponse, userInfo: [NSLocalizedDescriptionKey: "url-metrics response json in unexpected format. Expected Dictionary. Got\n\(json)"])
            
        }
    }
    
    func userFacingStringForHTTPStatusCode(code:Int) -> String? {
        
        switch code {
            
            
            
        default:
            return nil
        }
        
    }
}

public struct MZMozscapeIndexedDates {
    
    public static let LastKey = "IndexedLastDate"
    public static let NextKey = "IndexedNextDate"
    
    public let last:NSDate
    public let next:NSDate?
    
    static func testDates() -> MZMozscapeIndexedDates {
        return MZMozscapeIndexedDates(last: NSDate().dateByAddingTimeInterval(-(5 * 24 * 60 * 60)), next: nil)
    }
    
    init(last:NSDate, next:NSDate?) {
        self.last = last
        self.next = next
    }
    
    public init(json:JSON) throws {
        
        if let lastUnixDate = json["last_update"].double {
            
            last = NSDate(timeIntervalSince1970: lastUnixDate)
            
            if let nextUnixDate = json["next_update"].double {
                next = NSDate(timeIntervalSince1970: nextUnixDate)
            } else {
                next = nil
            }
            
        } else {
            throw NSError(InitUnexpectedResponseWithDescription: "Failed to create \(self.dynamicType). last_update not found in json: \(json)")
        }
    }
    
    public init?(info:[String:AnyObject]) {
        if let lastDate = info[MZMozscapeIndexedDates.LastKey] as? NSDate {
            last = lastDate
            next = info[MZMozscapeIndexedDates.NextKey] as? NSDate
        } else {
            return nil
        }
    }
    
    public var infoValue:[String:NSDate] {
        
        var info = [MZMozscapeIndexedDates.LastKey:last]
        info[MZMozscapeIndexedDates.NextKey] = next
        
        return info
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