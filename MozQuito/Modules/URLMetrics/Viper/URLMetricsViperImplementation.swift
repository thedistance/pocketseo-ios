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

class MZURLMetricsInteractor<ViewType:URLMetricsView>: URLMetricsInteractor {
    
    weak var presenter: MZURLMetricsPresenter<ViewType>?
    
    func getMozscapeMetricsForURLString(urlString: String) {
        
    }
    
    func getMozscapeIndexDates() {
        
    }
    
    func getPageMetaDataForURLString(url: String) {
        
    }
    
    func getAlexaDataFromURLString(url: String) {
        
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
        
    }
    
    func foundMozscapeMetrics(metrics:MZMozscapeMetrics) {
        
    }
    
    func failedToFindMozscapeMetricWithErrors(errors: [NSError]) {
        
        
    }
    
    func foundMozscapeIndexDates(dates: MZMozscapeIndexedDates) {
        
    }
    
    func foundPageMetaData(data: MZPageMetaData) {
        
    }
    
    func failedToFindPageMetaDataWithErrors(errors: [NSError]) {
        
    }
    
    func foundAlexaData(data: MZAlexaData) {
        
    }
    
    func failedToFindAlexaDataWithErrors(errors: [NSError]) {
        
    }
}

class MZURLMetricsWireframe<ViewType:URLMetricsView>: VIPERWireframe {
    
    weak var view:ViewType?
    
}