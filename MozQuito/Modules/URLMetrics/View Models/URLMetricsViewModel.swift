//
//  URLMetricsViewModel.swift
//  MozQuito
//
//  Created by Josh Campion on 04/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import Components
import SwiftyJSON

import ReactiveCocoa
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON

typealias MozscapeInfo = (metrics:MZMozscapeMetrics, dates:MZMozscapeIndexedDates?)

class MozscapeViewModel: ContentLoadingViewModel<Void, MozscapeInfo> {
    
    var urlString = MutableProperty<String?>(nil)
    
    let apiManager:APIManager
    
    init(apiManager:APIManager, lifetimeTrigger: ViewLifetime = .WillAppear, refreshFlattenStrategy: FlattenStrategy = .Latest) {
        
        self.apiManager = apiManager
        
        super.init(lifetimeTrigger: lifetimeTrigger, refreshFlattenStrategy: refreshFlattenStrategy)
        
        urlString.producer.observeOn(UIScheduler())
            .filter({ !($0?.isEmpty ?? true) })
            .combinePrevious(nil)
            .startWithNext { (prev, new) in
            
                if prev == new {
                    let refreshEvent = AnalyticEvent(category: .DataRequest, action: .refreshData, label: new)
                    MZAppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(refreshEvent)
                } else {
                    let requestEvent = AnalyticEvent(category: .DataRequest, action: .loadUrl, label: new)
                    MZAppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(requestEvent)
                }
        }
        
        // reload for each new urlString
        urlString.producer
            .combinePrevious(nil)
            .filter { $0 != $1 }
            .startWithNext { _ in self.refreshObserver.sendNext(()) }

    }
    
    override func loadingProducerWithInput(input: Void?) -> SignalProducer<MozscapeInfo, NSError> {
        
        guard let url = urlString.value
            where !url.isEmpty else { return SignalProducer.empty }
        
        let metricsProducer = apiManager.mozscapeURLMetricsForString(url)
        let datesProducer = apiManager.mozscapeIndexedDates()
        
        return combineLatest(metricsProducer, datesProducer).map({ (metrics: $0.0, dates: $0.1) })
    }
    

}