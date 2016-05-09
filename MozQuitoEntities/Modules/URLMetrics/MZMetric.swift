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
import Components
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON

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
    case EstablishedLinksRootDomains = "uipl"
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
            return 1024
        case .EstablishedLinksTotalLinks:
            return 2048
        }
    }
    
    static var paidValues:[MZMetricKey] {
        return [.Title, .CanonicalURL, .HTTPStatusCode, .DomainAuthority, .PageAuthority, .SpamScore, .EstablishedLinksRootDomains, .EstablishedLinksTotalLinks]
    }
    
    static var freeValues:[MZMetricKey] {
        return [.Title, .CanonicalURL, .HTTPStatusCode, .DomainAuthority, .PageAuthority, .EstablishedLinksTotalLinks, .TimeLastCrawled]
    }
    
}

public struct MZMozscapeMetrics {
    
    static func theDistanceMetrics() -> MZMozscapeMetrics {
        
        return MZMozscapeMetrics(HTTPStatusCode: 301,
                                 pageAuthority: 46.13596103561107,
                                 domainAuthority: 39.03236788583709,
                                 spamScore: 0,
                                 establishedLinksRoot: 86,
                                 establishedLinksTotal: 657,
                                 lastIndexed: NSDate(timeIntervalSince1970: 1459451654))
    }

    public let HTTPStatusCode:Int?
    
    public let pageAuthority:Double?
    public let pageAuthorityTotal:Int = 100
    
    public let domainAuthority:Double?
    public let domainAuthorityTotal:Int = 100
    
    public let spamScore:Double?
    public let spamScoreTotal:Int = 17
    
    public let establishedLinksRoot:Int?
    public let establishedLinksTotal:Int?
    
    public let lastIndexed:NSDate?
}

extension MZMozscapeMetrics: JSONCreated {
    public init(json:JSON) throws {
        
        if let results = json.dictionary {
            
            let keyResults:[MZMetricKey:JSON] = Dictionary(results.flatMap({ (str:String, value:JSON) -> (MZMetricKey, JSON)? in
                
                if let key = MZMetricKey(rawValue: str) {
                    return (key, value)
                } else {
                    return nil
                }
            }))
            
            let http = keyResults[.HTTPStatusCode]?.int
            let pageAuth = keyResults[.PageAuthority]?.double
            let domainAuth = keyResults[.DomainAuthority]?.double
            
            let root = keyResults[.EstablishedLinksRootDomains]?.int
            let total = keyResults[.EstablishedLinksTotalLinks]?.int
            
            let last = keyResults[.TimeLastCrawled]?.double
            
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
            
            if let lastDouble = last {
                self.lastIndexed = NSDate(timeIntervalSince1970: lastDouble)
            } else {
                self.lastIndexed = nil
            }
            
        } else {
            throw NSError.unexpectedTypeErrorForJSON(json, expectedType: .Dictionary)
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
    
    static func theDistanceDates() -> MZMozscapeIndexedDates {
        return MZMozscapeIndexedDates(last: NSDate(timeIntervalSince1970: 1459451654),
                                      next: NSDate(timeIntervalSince1970: 1462906800))
    }
    
    init(last:NSDate, next:NSDate?) {
        self.last = last
        self.next = next
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
