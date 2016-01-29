//
//  URLMetricsViperImplementation.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import MozQuitoEntities

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
        view?.showMozscapeMetrics(metrics)
    }
    
    func failedToFindMozscapeMetricWithErrors(errors: [NSError]) {
        view?.showMozscapeMetricsErrors(errors)
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
        view?.showAlexaData(data)
    }
    
    func failedToFindAlexaDataWithErrors(errors: [NSError]) {
        view?.showAlexaDataErrors(errors)
    }
}
