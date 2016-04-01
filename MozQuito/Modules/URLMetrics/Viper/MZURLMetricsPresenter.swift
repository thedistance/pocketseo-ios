//
//  URLMetricsViperImplementation.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
//import PocketSEOEntities

class MZURLMetricsPresenter<ViewType:URLMetricsView>: URLMetricsPresenter {
    
    weak var view:ViewType?
    var interactor:MZURLMetricsInteractor<ViewType>?
    var wireframe:MZURLMetricsWireframe<ViewType>?
    
    required init() { }
    
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
    
    func refreshMetricsForURLString(urlString: String) {
        
        let refreshEvent = AnalyticEvent(category: .DataRequest, action: .refreshData, label: urlString)
        AppDependencies.sharedDependencies().analyticsInteractor?.sendAnalytic(refreshEvent)
        
        // no need to refresh the indexed dates and the mozscape data as they change ~monthly.
        interactor?.getPageMetaDataForURLString(urlString)
        interactor?.getMozscapeMetricsForURLString(urlString)
        interactor?.getAlexaDataFromURLString(urlString)
    }
    
    func requestMetricsForURLString(urlString:String) {
        
        let requestEvent = AnalyticEvent(category: .DataRequest, action: .loadUrl, label: urlString)
        AppDependencies.sharedDependencies().analyticsInteractor?.sendAnalytic(requestEvent)
        
        let screenView = AnalyticEvent(screenName: .URLMetrics)
        AppDependencies.sharedDependencies().analyticsInteractor?.sendAnalytic(screenView)
        
        if MZAppDependencies.sharedDependencies().shouldIgnoreCacheForRequest(.MozscapeIndexedDates) {
            interactor?.getMozscapeIndexDates()
        } else {
            if let dates = NSUserDefaults.standardUserDefaults().dictionaryForKey(RequestKeys.MozscapeIndexedDates.rawValue),
                let mzDates = MZMozscapeIndexedDates(info: dates) {
                foundMozscapeIndexDates(mzDates)
            }
        }
        
        interactor?.getPageMetaDataForURLString(urlString)
        interactor?.getAlexaDataFromURLString(urlString)
        interactor?.getMozscapeMetricsForURLString(urlString)
        
    }
    
    func foundMozscapeMetrics(metrics:MZMozscapeMetrics) {
        view?.showMozscapeMetrics(metrics)
    }
    
    func failedToFindMozscapeMetricWithErrors(errors: [NSError]) {
        view?.showMozscapeMetricsErrors(errors)
    }
    
    func foundMozscapeIndexDates(dates: MZMozscapeIndexedDates) {
        
        NSUserDefaults.standardUserDefaults().setObject(dates.infoValue, forKey: RequestKeys.MozscapeIndexedDates.rawValue)
        view?.showMozscapeIndexedDates(dates)
    }
    
    func foundPageMetaData(data: MZPageMetaData) {
        view?.showPageMetaData(data)
    }
    
    func failedToFindPageMetaDataWithErrors(errors: [NSError]) {
        view?.showPageMetaDataErrors(errors)
    }
    
    func foundAlexaData(data: MZAlexaData) {
        view?.showAlexaData(data)
    }
    
    func failedToFindAlexaDataWithErrors(errors: [NSError]) {
        view?.showAlexaDataErrors(errors)
    }
}
