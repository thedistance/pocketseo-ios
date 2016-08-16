//
//  LinksViewModel.swift
//  MozQuito
//
//  Created by Ashhad Syed on 05/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import Components

import ReactiveCocoa
import ReactiveCocoaConvenience_Alamofire_SwiftyJSON

typealias LinksOutput = PagedOutput<MZMozscapeLinks>

class MozscapeLinksViewModel: PagingContentLoadingViewModel<MZMozscapeLinks> {
    
    var urlString = MutableProperty<String?>(nil)
    
    var searchConfiguration = MutableProperty<LinkSearchConfiguration>(LinkSearchConfiguration.defaultConfiguration())
    
    let apiManager:APIManager
    
    init(apiManager:APIManager, lifetimeTrigger: ViewLifetime = .Init, refreshFlattenStrategy: FlattenStrategy = .Latest) {
        
        self.apiManager = apiManager
        
        super.init(lifetimeTrigger: lifetimeTrigger, refreshFlattenStrategy: refreshFlattenStrategy)
        
        // reload for each new urlString
        urlString.producer
            .combinePrevious(nil)
            .filter { $0 != $1 }
            .startWithNext { _ in self.refreshObserver.sendNext(false) }
        
        // reload for each new search configuration
        searchConfiguration.producer
            .combinePrevious(LinkSearchConfiguration.defaultConfiguration())
            .filter { $0 != $1 }
            .startWithNext { _ in self.refreshObserver.sendNext(false) }
    }
    
    override func contentForPage(page: UInt) -> SignalProducer<[MZMozscapeLinks], NSError> {
        
        guard let url = urlString.value
            where !url.isEmpty else { return SignalProducer.empty }

        
        return apiManager.mozscapeLinksForString(url,
                                                 requestURLParameters: searchConfiguration.value,
                                                 page: page, count: pageCount.value)
    }
}