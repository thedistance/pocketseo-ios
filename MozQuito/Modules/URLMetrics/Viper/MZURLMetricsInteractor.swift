////
////  MZURLMetricsInteractor.swift
////  MozQuito
////
////  Created by Josh Campion on 29/01/2016.
////  Copyright © 2016 The Distance. All rights reserved.
////
//
//import Foundation
//import PSOperations
//
////import PocketSEOEntities
//
//class MZURLMetricsInteractor<ViewType:URLMetricsView>: URLMetricsInteractor {
//    
//    var operationQueue = OperationQueue()
//    
//    weak var presenter: MZURLMetricsPresenter<ViewType>?
//    
//    required init() { }
//    
//    func getMozscapeMetricsForURLString(urlString: String) {
//        
//        let metricsOperation = MZGetMozscapeURLMetricsOperation(requestURLString: urlString)
//        
//        metricsOperation.success = { (metrics) in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.presenter?.foundMozscapeMetrics(metrics)
//            })
//        }
//        
//        metricsOperation.failure = { (errors) in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.presenter?.failedToFindMozscapeMetricWithErrors(errors)
//            })
//        }
//        
//        operationQueue.addOperation(metricsOperation)
//    }
//    
//    func getMozscapeIndexDates() {
//        
//        let indexDates = MZGetMozscapeIndexDatesOperation()
//        
//        indexDates.success = { (dates) in
//            
//            MZAppDependencies.sharedDependencies().successfullyRequested(.MozscapeIndexedDates)
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.presenter?.foundMozscapeIndexDates(dates)
//            })
//        }
//        
//        operationQueue.addOperation(indexDates)
//    }
//    
//    func getPageMetaDataForURLString(urlString: String) {
//        
//        let invalidUserInput:() -> () = {
//            let inputError = NSError(domain: MZErrorDomain.UserInputError, code: MZErrorCode.InvalidURL, userInfo: [NSLocalizedDescriptionKey: "Invalid URL Entered."])
//            self.presenter?.failedToFindPageMetaDataWithErrors([inputError])
//        }
//        
//        guard var url = NSURL(string: urlString) else {
//            invalidUserInput()
//            return
//        }
//        
//        
//        if url.scheme.isEmpty {
//            if let guessURL = NSURL(string: "http://\(urlString)") {
//                url = guessURL
//            } else {
//                invalidUserInput()
//            }
//        }
//        
//        
//        let metaDataOperation = MZGetPageMetaDataOperation(url: url)
//        
//        metaDataOperation.success = { (data) in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.presenter?.foundPageMetaData(data)
//            })
//        }
//        
//        metaDataOperation.failure = { (errors) in
//            
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.presenter?.failedToFindPageMetaDataWithErrors(errors)
//            })
//        }
//        
//        operationQueue.addOperation(metaDataOperation)
//    }
//}