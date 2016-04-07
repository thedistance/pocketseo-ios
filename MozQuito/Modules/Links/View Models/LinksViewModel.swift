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

class MozscapeLinksViewModel: ContentLoadingViewModel<(urlRequest:String, nextPage:Bool), LinksOutput> {
    
    var currentRequestString:String?
    
    let apiManager:APIManager
    
    private let pageCount:UInt = 25
    
    init(apiManager:APIManager, lifetimeTrigger: ViewLifetime = .WillAppear, refreshFlattenStrategy: FlattenStrategy = .Latest) {
        
        self.apiManager = apiManager
        
        super.init(lifetimeTrigger: lifetimeTrigger, refreshFlattenStrategy: refreshFlattenStrategy)
    }
    
    override func loadingProducerWithInput(input: (urlRequest:String, nextPage:Bool)?) -> SignalProducer<LinksOutput, NSError> {
        
        guard let (url, nextPage) = input
            where !url.isEmpty else { return SignalProducer.empty }
        
        let reload = !nextPage || url != currentRequestString
        
        let page:UInt
        
        if reload {
            
            loadedContent = nil
            currentRequestString = url
            page = 0
            
        } else if loadedContent?.moreAvailable ?? true {
            
            let currentCount = loadedContent?.links.count ?? 0
            page = UInt(currentCount) / pageCount
            
        } else {
            return SignalProducer.empty
        }
        
        let currentContent = LinksOutput(links:[MZMozscapeLinks](), moreAvailable:true)
        return apiManager.mozscapeLinksForString(url, page: page, count: pageCount)
            .scan(loadedContent ?? currentContent) {
                
                let aggregatedLinks = $0.links + $1
                let moreAvailable = UInt($1.count) == self.pageCount
                
                return LinksOutput(links: aggregatedLinks, moreAvailable: moreAvailable )
        }
    }
}