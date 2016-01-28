//
//  MZPageMetaData.swift
//  MozQuito
//
//  Created by Josh Campion on 27/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

struct MZHTMLMetaData {
    let title:String?
    let canonicalURL:NSURL?
    let description:String?
    let h1Tags:[String]
    let h2Tags:[String]
    
    var titleCharacterCount:Int? {
        return title?.characters.count
    }
    
    var canonicalURLCharacterCount:Int? {
        return canonicalURL?.absoluteString.characters.count
    }
    
    var descriptionCharacterCount:Int? {
        return description?.characters.count
    }
    
    var h1TagsCharacterCount:Int {
        return h1Tags.reduce(0, combine: { $0 + $1.characters.count })
    }
    
    var h2TagsCharacterCount:Int {
        return h2Tags.reduce(0, combine: { $0 + $1.characters.count })
    }
}

struct MZPageMetaData {
    
    let htmlMetaData:MZHTMLMetaData
    let usingSSL:Bool
    let requestDate:NSDate
    
    init(htmlData:MZHTMLMetaData, usingSSL:Bool, requestDate:NSDate) {
        
        htmlMetaData = htmlData
        self.usingSSL = usingSSL
        self.requestDate = requestDate
    }
}