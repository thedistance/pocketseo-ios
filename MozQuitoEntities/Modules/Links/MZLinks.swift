//
//  MZLinks.swift
//  MozQuito
//
//  Created by Ashhad Syed on 05/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import TheDistanceCore
import SwiftyJSON
import Components
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON

public enum MZLinksKey: String {
    case Title = "ut"
    case CanonicalURL = "uu"
    case PageAuthority = "upa"
    case DomainAuthority = "pda"
    case SpamScore = "fspsc"
    case AnchorText = "lnt"
    case NoFollow = "lf"
    
    public var colValue:UInt64 {
        switch(self) {
        case .Title:
            return 1
        case .CanonicalURL:
            return 4
        case .DomainAuthority:
            return 68719476736
        case .PageAuthority:
            return 34359738368
        case .SpamScore:
            return 67108864
        case .AnchorText:
            return 8
        case .NoFollow:
            return 2
        }
    }
    
}

public struct MZMozscapeLinks: ContentEquatable {
    
    public let title:String?
    public let canonicalURL:NSURL?
    public let pageAuthority:Double?
    public let domainAuthority:Double?
    public let spamScore:SpamScore
    public let anchorText:String?
    public let noFollow:Bool
    
    public init(title:String, canonicalURL:NSURL?, pageAuthority:Double?, domainAuthority:Double?, spamScore:Double?, anchorText:String?, noFollow:Bool) {
        
        self.title = title
        self.canonicalURL = canonicalURL
        self.pageAuthority = pageAuthority
        self.domainAuthority = domainAuthority
        self.spamScore = SpamScore(score: spamScore)
        self.anchorText = anchorText
        self.noFollow = noFollow
    }
    
    public static func theDistanceLinks() -> MZMozscapeLinks {
        
        return MZMozscapeLinks(title: "User Anthony Main - Stack Overflow",
                               canonicalURL: NSURL(string: "stackoverflow.com/users/258/anthony-main"),
                               pageAuthority: 47.99038445765669,
                               domainAuthority: 92.89606377307786,
                               spamScore: 4,
                               anchorText: "thedistance.co.uk",
                               noFollow: true)
    }
    
    public static func theDistanceLinks1() -> MZMozscapeLinks {
        
        return MZMozscapeLinks(title: "The Distance - Awwwards",
                               canonicalURL: NSURL(string: "www.awwwards.com/TheDistanceHQ/favourites"),
                               pageAuthority: 30.92693328768593,
                               domainAuthority: 80.07206867111411,
                               spamScore: 3,
                               anchorText: "thedistance.co.uk",
                               noFollow: true)
    }

    public func contentMatches(other: MZMozscapeLinks) -> Bool {
        
        let r1 = self
        let r2 = other
        
        return r1.title == r2.title &&
            r1.canonicalURL == r2.canonicalURL &&
            r1.pageAuthority == r2.pageAuthority &&
            r1.domainAuthority == r2.domainAuthority &&
            r1.spamScore == r2.spamScore &&
            r1.anchorText == r2.anchorText &&
            r1.noFollow == r2.noFollow
    }
}

extension MZMozscapeLinks: JSONCreated {
    public init(json: JSON) throws {
        
        if let results = json.dictionary {
            
            let keyResults:[MZLinksKey:JSON] = Dictionary(results.flatMap({ (str:String, value:JSON) -> (MZLinksKey, JSON)? in
                
                if let key = MZLinksKey(rawValue: str) {
                    return (key,value)
                } else {
                    return nil
                }
            }))
            
            self.title = keyResults[.Title]?.string
            
            if let canURLString = keyResults[.CanonicalURL]?.string {
                self.canonicalURL = NSURL(string: canURLString)
            } else {
                self.canonicalURL = nil
            }
            self.pageAuthority = keyResults[.PageAuthority]?.double
            self.domainAuthority = keyResults[.DomainAuthority]?.double
            
            if let s = keyResults[.SpamScore]?.double where s > 0 {
                self.spamScore = SpamScore.init(score: s - 1.0)
            } else {
                self.spamScore = SpamScore.init(score: nil)
            }
            
            self.anchorText = keyResults[.AnchorText]?.string
            self.noFollow = keyResults[.NoFollow]?.bool ?? false
            
        } else {
            throw NSError.unexpectedTypeErrorForJSON(json, expectedType: .Dictionary)
        }
    }
}

public func == (r1:MZMozscapeLinks, r2:MZMozscapeLinks) -> Bool {
    
    return r1.title == r2.title &&
        r1.canonicalURL == r2.canonicalURL
}

extension MZMozscapeLinks: Listable {
    
    public func getListProperties() -> ListProperties {
        
        return(title: self.title,
            subtitle: self.canonicalURL?.absoluteString,
            image: nil,
            imageURL:nil)
    }
}

