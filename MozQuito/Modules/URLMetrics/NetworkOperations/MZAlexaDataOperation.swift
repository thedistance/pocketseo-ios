//
//  MZAlexaDataOperation.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import Alamofire
import hpple

class MZAlexaDataOperation: FailingOperation {

    var success:((data:MZAlexaData) -> ())?
    
    let urlString:String
    
    init(urlString:String) {
        self.urlString = urlString
    }
    
    override func execute() {
        
        
    }
    
}

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
        
        let reachElements = xmlDoc.searchWithXPathQuery("//REACH")
        
        let rankElements = xmlDoc.searchWithXPathQuery("//RANK")
        
        self.finish([NSError(InitUnexpectedResponseWithDescription: "Not Yet Implemented")])
    }
}