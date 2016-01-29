//
//  MZGetPageMetaDataOperation.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import MozQuitoEntities
import Alamofire

class MZGetPageMetaDataOperation: FailingOperation {

    let requestURL:NSURL
    
    var success:((data:MZPageMetaData) -> ())?
    
    
    init(url:NSURL) {
        requestURL = url
    }
    
    override func execute() {
        
        Alamofire.request(.GET, requestURL.absoluteString)
        .validate(contentType: ["text/html"])
        .responseData { (response) -> Void in
            
            switch response.result {
            case .Success(let data):
                
                let parseOperation = MZParseHTMLDataOperation(data: data)
                
                parseOperation.success = { (htmlMeta) in
                    
                    let responseURL = response.response?.URL
                    
                    let pageMeta = MZPageMetaData(htmlData: htmlMeta,
                        usingSSL: (responseURL?.scheme == "https") ?? false,
                        requestDate: NSDate())
                    
                    self.success?(data: pageMeta)
                    self.finish()
                }
                
                parseOperation.failure = { (errors) in
                    self.finish(errors)
                }
                
                self.produceOperation(parseOperation)
                
            case .Failure(let error):
                self.finish([error])
            }
        }
    }
}
