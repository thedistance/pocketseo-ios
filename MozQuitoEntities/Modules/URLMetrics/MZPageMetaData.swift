//
//  MZPageMetaData.swift
//  MozQuito
//
//  Created by Josh Campion on 27/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

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