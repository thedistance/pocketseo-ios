//
//  URLMetricsViewModel.swift
//  MozQuito
//
//  Created by Josh Campion on 04/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import Components

import ReactiveCocoa
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON

typealias MozscapeInfo = (metrics:MZMozscapeMetrics, dates:MZMozscapeIndexedDates?)

class MozscapeViewModel: ContentLoadingViewModel<String, MozscapeInfo> {
    
    let apiManager:APIManager
    
    init(apiManager:APIManager, lifetimeTrigger: ViewLifetime = .WillAppear, refreshFlattenStrategy: FlattenStrategy = .Latest) {
        
        self.apiManager = apiManager
        
        super.init(lifetimeTrigger: lifetimeTrigger, refreshFlattenStrategy: refreshFlattenStrategy)
    }
    
    override func loadingProducerWithInput(input: String?) -> SignalProducer<MozscapeInfo, NSError> {
        
        let metricsProducer = apiManager.mozscapeURLMetricsForString(input ?? "")
        let datesProducer = apiManager.mozscapeIndexedDates()
        
        return combineLatest(metricsProducer, datesProducer).map({ (metrics: $0.0, dates: $0.1) })
    }
    
}