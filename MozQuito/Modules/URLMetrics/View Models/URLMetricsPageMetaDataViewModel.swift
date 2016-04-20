//
//  URLMetricsPageMetaDataViewModel.swift
//  MozQuito
//
//  Created by Ashhad Syed on 18/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import Components
import SwiftyJSON

import ReactiveCocoa
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON

class PageMetaDataViewModel: ContentLoadingViewModel<Void, MZPageMetaData> {
    
    var urlString = MutableProperty<String?>(nil)
    
    let apiManager:APIManager
    
    init(apiManager:APIManager, lifetimeTrigger: ViewLifetime = .WillAppear, refreshFlattenStrategy: FlattenStrategy = .Latest) {
        
        self.apiManager = apiManager
        
        super.init(lifetimeTrigger: lifetimeTrigger, refreshFlattenStrategy: refreshFlattenStrategy)
        
        // reload for each new urlString
        urlString.producer
            .combinePrevious(nil)
            .filter { $0 != $1 }
            .startWithNext { _ in self.refreshObserver.sendNext(()) }
    }
    
    override func loadingProducerWithInput(input: Void?) -> SignalProducer<MZPageMetaData, NSError> {
        
        guard let url = urlString.value
            where !url.isEmpty else { return SignalProducer.empty }
        
        return apiManager.htmlMetaDataForString(url)
    }
    
}