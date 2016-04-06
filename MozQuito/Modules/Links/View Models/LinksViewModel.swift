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

class MozscapeLinksViewModel: ContentLoadingViewModel<String, [MZMozscapeLinks]> {
    
    let apiManager:APIManager
    
    init(apiManager:APIManager, lifetimeTrigger: ViewLifetime = .WillAppear, refreshFlattenStrategy: FlattenStrategy = .Latest) {
        
        self.apiManager = apiManager
        
        super.init(lifetimeTrigger: lifetimeTrigger, refreshFlattenStrategy: refreshFlattenStrategy)
    }
    
    override func loadingProducerWithInput(input: String?) -> SignalProducer<[MZMozscapeLinks], NSError> {
        
        let linksProducer = apiManager.mozscapeLinksForString(input ?? "")
        
        return linksProducer
    }
    
}