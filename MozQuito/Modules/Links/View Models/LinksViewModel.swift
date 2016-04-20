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

struct LinksOutput {
    let links:[MZMozscapeLinks]
    let moreAvailable:Bool
}

extension LinksOutput: ListLoadingModel {
    
    typealias ValueType = MZMozscapeLinks
    
    func totalNumberOfEntities() -> Int {
        return links.totalNumberOfEntities()
    }
    
    func numberOfSectionsInList() -> Int {
        return links.numberOfSectionsInList()
    }
    
    func numberOfEntitiesInSection(section: Int) -> Int {
        return links.numberOfEntitiesInSection(section)
    }
    
    func entityForIndexPath(indexPath: NSIndexPath) -> MZMozscapeLinks? {
        return links.entityForIndexPath(indexPath)
    }
    
}

class MozscapeLinksViewModel: ContentLoadingViewModel<Bool, LinksOutput> {
    
    var urlString = MutableProperty<String?>(nil)
    
    var searchConfiguration = MutableProperty<LinkSearchConfiguration>(LinkSearchConfiguration.defaultConfiguration())
    
    let apiManager:APIManager
    
    private let pageCount:UInt = 25
    
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
    
    override func loadingProducerWithInput(nextPage: Bool?) -> SignalProducer<LinksOutput, NSError> {
        
        guard let url = urlString.value
            where !url.isEmpty else { return SignalProducer.empty }
        
        let page:UInt
        
        let currentContent:LinksOutput
        
        if nextPage ?? false {
            
            let currentCount = loadedContent?.links.count ?? 0
            page = UInt(currentCount) / pageCount
            currentContent = loadedContent ?? LinksOutput(links:[MZMozscapeLinks](), moreAvailable:true)
            
        } else {
            
            currentContent = LinksOutput(links:[MZMozscapeLinks](), moreAvailable:true)
            page = 0
        }
        
        
        return apiManager.mozscapeLinksForString(url,
            requestURLParameters: searchConfiguration.value,
            page: page, count: pageCount)
            .scan(currentContent) {
                
                let aggregatedLinks = $0.links + $1
                let moreAvailable = UInt($1.count) == self.pageCount
                
                return LinksOutput(links: aggregatedLinks, moreAvailable: moreAvailable )
        }
    }
}