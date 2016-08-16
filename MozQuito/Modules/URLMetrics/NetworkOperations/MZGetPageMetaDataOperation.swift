////
////  MZGetPageMetaDataOperation.swift
////  MozQuito
////
////  Created by Josh Campion on 28/01/2016.
////  Copyright © 2016 The Distance. All rights reserved.
////
//
//import UIKit
//
////import PocketSEOEntities
//
//import Alamofire
//import PSOperations
//
//class MZGetPageMetaDataOperation: FailingOperation {
//
//    let requestURL:NSURL
//    
//    var success:((data:MZPageMetaData) -> ())?
//    
//    
//    init(url:NSURL) {
//        requestURL = url
//        
//        super.init()
//        
//        addCondition(MutuallyExclusive<MZGetPageMetaDataOperation>())
//    }
//    
//    override func execute() {
//        
//        Alamofire.request(.GET, requestURL.absoluteString)
//        .validate(contentType: ["text/html"])
//        .responseData { (response) -> Void in
//            
//            switch response.result {
//            case .Success(let data):
//                
//                let parseOperation = MZParseHTMLDataOperation(data: data)
//                
//                parseOperation.success = { (htmlMeta) in
//                    
//                    guard let responseURL = response.response?.URL else {
//                        let error = NSError(domain: .HTMLError,
//                            code: .UnexpectedResponse,
//                            userInfo: [NSLocalizedDescriptionKey:"No response found."])
//                        self.finish([error])
//                        return
//                    }
//                    
//                    let pageMeta = MZPageMetaData(htmlData: htmlMeta,
//                        usingSSL: (responseURL.scheme == "https") ?? false,
//                        requestDate: NSDate(),
//                        responseURL: responseURL
//                    )
//                    
//                    self.success?(data: pageMeta)
//                    self.finish()
//                }
//                
//                parseOperation.failure = { (errors) in
//                    self.finish(errors)
//                }
//                
//                self.produceOperation(parseOperation)
//                
//            case .Failure(let error):
//                self.finish([error])
//            }
//        }
//    }
//}
//
