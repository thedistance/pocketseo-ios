//
//  MZParseAlexaDataOperation.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import hpple
import MozQuitoEntities

class MZParseAlexaDataOperation: FailingOperation {
    
    var success:((data:MZAlexaData) -> ())?
    
    let xmlData:NSData
    
    init(data:NSData) {
        xmlData = data
    }
    
    override func execute() {
        
        guard let xmlDoc = TFHpple(XMLData: xmlData) else {
            
            let error = NSError(domain: .XMLError, code: .UnexpectedResponse, userInfo: [NSLocalizedDescriptionKey: "Unable to create hpple XML Document from data."])
            self.finish([error])
            return
        }
        
        let popularityElements = xmlDoc.searchWithXPathQuery("//POPULARITY")
        let popString = (popularityElements.first as? TFHppleElement)?.attributes["TEXT"] as? String
        
        let reachElements = xmlDoc.searchWithXPathQuery("//REACH")
        let reachString = (reachElements.first as? TFHppleElement)?.attributes["RANK"] as? String
        
        let rankElements = xmlDoc.searchWithXPathQuery("//RANK")
        let rankString = (rankElements.first as? TFHppleElement)?.attributes["DELTA"] as? String
        
        let data = MZAlexaData(popularityText: popString,
            reachRank: reachString,
            rankDelta: rankString)
        
        self.success?(data: data)
        self.finish()
    }
}