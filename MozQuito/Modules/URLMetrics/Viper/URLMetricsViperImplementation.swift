//
//  URLMetricsViperImplementation.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ViperKit

class MZURLMetricsInteractor<ViewType:URLMetricsView>: URLMetricsInteractor {
    
    weak var presenter: MZURLMetricsPresenter<ViewType>?
    
    func getMetricsForURL(url:NSURL) {
        
    }
    
    func getMetricsForURLString(urlString:String) {
        
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
    
    func requestMetricsForURL(url:NSURL) {
        
    }
    
    func requestMetricsForURLString(urlString:String) {
        
    }
    
    func foundMetrics(metrics:[MZMetric]) {
        
    }
    
    func failedToFindMetricsForURL(url:NSURL, withErrors:[NSError]) {
        
    }
}

class MZURLMetricsWireframe<ViewType:URLMetricsView>: VIPERWireframe {
    
    weak var view:ViewType?
    
}