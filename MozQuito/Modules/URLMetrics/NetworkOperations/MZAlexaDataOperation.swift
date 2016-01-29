//
//  MZAlexaDataOperation.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import Alamofire

class MZAlexaDataOperation: FailingOperation {

    var success:((data:MZAlexaData) -> ())?
    
    let urlString:String
    
    init(urlString:String) {
        self.urlString = urlString
    }
    
    override func execute() {
        
        Alamofire.request(.GET,
            BaseURL.Alexa,
            parameters: ["cli": 10, "dat": "snbamz", "url": urlString],
            encoding: .URL,
            headers: nil)
        .validate()
        .responseData { (response) -> Void in
            
            switch response.result {
            case .Success(let data):
                
                let parseOperation = MZParseAlexaDataOperation(data: data)
                
                parseOperation.success = { (data) in
                    self.success?(data: data)
                    self.finish()
                }
                
                parseOperation.failure = self.failure
                
                self.produceOperation(parseOperation)
                
            case .Failure(let error):
                self.finish([error])
            }
        }
    }
}

