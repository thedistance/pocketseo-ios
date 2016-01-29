//
//  URLMetricsViperImplementation.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ViperKit
import MozQuitoEntities
import PSOperations

class MZURLMetricsInteractor<ViewType:URLMetricsView>: URLMetricsInteractor {
    
    var operationQueue = OperationQueue()
    
    weak var presenter: MZURLMetricsPresenter<ViewType>?
    
    func getMozscapeMetricsForURLString(urlString: String) {
        
    }
    
    func getMozscapeIndexDates() {
        
        let indexDates = MZGetMozscapeIndexDatesOperation()
        
        indexDates.success = { (dates) in
            
            MZAppDependencies.sharedDependencies().successfullyRequested(.MozscapeIndexedDates)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presenter?.foundMozscapeIndexDates(dates)
            })
        }
        
        operationQueue.addOperation(indexDates)
    }
    
    func getPageMetaDataForURLString(urlString: String) {
        
        let invalidUserInput:() -> () = {
            let inputError = NSError(domain: MZErrorDomain.UserInputError, code: MZErrorCode.InvalidURL, userInfo: [NSLocalizedDescriptionKey: "Invalid URL Entered."])
            self.presenter?.failedToFindPageMetaDataWithErrors([inputError])
        }
        
        guard var url = NSURL(string: urlString) else {
            invalidUserInput()
            return
        }
        
        
        if url.scheme.isEmpty {
            if let guessURL = NSURL(string: "http://\(urlString)") {
                url = guessURL
            } else {
                invalidUserInput()
            }
        }
        
        
        let metaDataOperation = MZGetPageMetaDataOperation(url: url)

        metaDataOperation.success = { (data) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presenter?.foundPageMetaData(data)
            })
        }
        
        metaDataOperation.failure = { (errors) in
         
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presenter?.failedToFindPageMetaDataWithErrors(errors)
            })
        }
        
        operationQueue.addOperation(metaDataOperation)
    }
    
    func getAlexaDataFromURLString(urlString: String) {
        
    }
}

class MZURLMetricsPresenter<ViewType:URLMetricsView>: URLMetricsPresenter {
    
    weak var view:ViewType?
    var interactor:MZURLMetricsInteractor<ViewType>?
    var wireframe:MZURLMetricsWireframe<ViewType>?
    
    static func configuredPresenterForView(view:ViewType) -> MZURLMetricsPresenter<ViewType> {
        
        let presenter = MZURLMetricsPresenter<ViewType>()
        let interactor = MZURLMetricsInteractor<ViewType>()
        let wireframe = MZURLMetricsWireframe<ViewType>()
        
        interactor.presenter = presenter
        
        presenter.interactor = interactor
        presenter.view = view
        presenter.wireframe = wireframe
        
        wireframe.view = view
        
        return presenter
    }
    
    func requestMetricsForURLString(urlString:String) {
        
        if MZAppDependencies.sharedDependencies().shouldIgnoreCacheForRequest(.MozscapeIndexedDates) {
            interactor?.getMozscapeIndexDates()
        } else {
            if let dates = NSUserDefaults.valueForKey(RequestKeys.MozscapeIndexedDates.rawValue) as? [String:AnyObject],
                let mzDates = MZMozscapeIndexedDates(info: dates) {
                foundMozscapeIndexDates(mzDates)
            }
        }
        
        interactor?.getPageMetaDataForURLString(urlString)
        interactor?.getAlexaDataFromURLString(urlString)
        interactor?.getMozscapeMetricsForURLString(urlString)
        
    }
    
    func foundMozscapeMetrics(metrics:MZMozscapeMetrics) {
        
    }
    
    func failedToFindMozscapeMetricWithErrors(errors: [NSError]) {
        
        
    }
    
    func foundMozscapeIndexDates(dates: MZMozscapeIndexedDates) {
        
        NSUserDefaults.standardUserDefaults().setValue(dates.infoValue, forKey: RequestKeys.MozscapeIndexedDates.rawValue)
        view?.showMozscapeIndexedDates(dates)
    }
    
    func foundPageMetaData(data: MZPageMetaData) {
        view?.showPageMetaData(data)
    }
    
    func failedToFindPageMetaDataWithErrors(errors: [NSError]) {
        view?.showPageMetaDataErrors(errors)
    }
    
    func foundAlexaData(data: MZAlexaData) {
        
    }
    
    func failedToFindAlexaDataWithErrors(errors: [NSError]) {
        
    }
}

class MZURLMetricsWireframe<ViewType:URLMetricsView>: VIPERWireframe {
    
    weak var view:ViewType?
    
}