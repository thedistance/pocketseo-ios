//
//  MZPageMetaData.swift
//  MozQuito
//
//  Created by Josh Campion on 27/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import hpple

public struct MZHTMLMetaData {
    public let title:String?
    public let canonicalURL:NSURL?
    public let description:String?
    public let h1Tags:[String]
    public let h2Tags:[String]
    
    public init(title:String?, canonicalURL:NSURL?, description:String?, h1Tags:[String], h2Tags:[String]) {
        self.title = title
        self.canonicalURL = canonicalURL
        self.description = description
        self.h1Tags = h1Tags
        self.h2Tags = h2Tags
    }
    
    public static func TheDistanceMetaData() -> MZHTMLMetaData {
        return MZHTMLMetaData(title: "App Developers UK | Mobile App Development | The Distance, York",
            canonicalURL: NSURL(string: "https://thedistance.co.uk/")!,
            description: "We are award winning UK app developers UK who develop mobile app development solutions for IOS & Android for B2C, B2B & Enterprise. Call York team today.",
            h1Tags: ["The Yorkshire & UK leading mobile app developers"],
            h2Tags: ["Mobile App Consultancy",
                "Mobile App Development",
                "Mobile App UI/UX",
                "Trusted By",
                "OUR TOOLS",
                "PLATFORMS",
                "TELL US YOUR APP IDEA"])
    }
    
    public var titleCharacterCount:Int? {
        return title?.characters.count
    }
    
    public var canonicalURLCharacterCount:Int? {
        return canonicalURL?.absoluteString.characters.count
    }
    
    public var descriptionCharacterCount:Int? {
        return description?.characters.count
    }
    
    public var h1TagsCharacterCount:Int {
        return h1Tags.reduce(0, combine: { $0 + $1.characters.count })
    }
    
    public var h2TagsCharacterCount:Int {
        return h2Tags.reduce(0, combine: { $0 + $1.characters.count })
    }
}

extension MZHTMLMetaData {
    
    init(htmlData:NSData) throws {
        
        guard let htmlDoc = TFHpple(HTMLData: htmlData) else {
            
            let error = NSError(domain: .HTMLError, code: .UnexpectedResponse, userInfo: [NSLocalizedDescriptionKey: "Unable to create hpple HTML Document from data."])
            throw error
        }
        
        let titleElements = htmlDoc.searchWithXPathQuery("//title")
        let title = (titleElements.first as? TFHppleElement)?.allText()
        
        let canonicalElements = htmlDoc.searchWithXPathQuery("//link[@rel='canonical']")
        let canonical = (canonicalElements.first as? TFHppleElement)?.attributes["href"] as? String
        let canonicalURL:NSURL?
        if let cStr = canonical {
            canonicalURL = NSURL(string: cStr)
        } else {
            canonicalURL = nil
        }
        
        
        let descriptionElements = htmlDoc.searchWithXPathQuery("//meta[@name='description']")
        let description = (descriptionElements.first as? TFHppleElement)?.attributes["content"] as? String
        
        let h1Elements = htmlDoc.searchWithXPathQuery("//h1")
        let h1Tags = h1Elements.flatMap({ ($0 as? TFHppleElement)?.allText() })
        
        let h2Elements = htmlDoc.searchWithXPathQuery("//h2")
        let h2Tags = h2Elements.flatMap({ ($0 as? TFHppleElement)?.allText() })
        
        self.init(title: title,
                  canonicalURL: canonicalURL,
                  description: description,
                  h1Tags: h1Tags,
                  h2Tags: h2Tags)
    }
}

public struct MZPageMetaData {
    
    public let htmlMetaData:MZHTMLMetaData
    public let usingSSL:Bool
    public let requestDate:NSDate
    public let responseURL:NSURL
    
    public init(htmlData:MZHTMLMetaData, usingSSL:Bool, requestDate:NSDate, responseURL:NSURL) {
        
        htmlMetaData = htmlData
        self.usingSSL = usingSSL
        self.requestDate = requestDate
        self.responseURL = responseURL
    }
    
    public static func TheDistanceMetaData() -> MZPageMetaData {
        
        return MZPageMetaData(htmlData: MZHTMLMetaData.TheDistanceMetaData(),
            usingSSL: true,
            requestDate: NSDate(),
            responseURL: NSURL(string: "https://thedistance.co.uk")!
        )
    }
}