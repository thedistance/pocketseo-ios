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

/*
struct BackLink: ContentEquatable {

    static func distanceBackLink() -> BackLink {
        return BackLink()
    }
    
    func contentMatches(other: BackLink) -> Bool {
        return true
    }
}

func ==(b1:BackLink, b2:BackLink) -> Bool {
    return false
}

extension BackLink: JSONCreated {

    init(json: JSON) throws { }
}
*/

/*
typealias LinksOutput = (links:[MZMozscapeLinks], moreAvailable:Bool)

class LinksViewModel: ContentLoadingViewModel<(urlRequest:String, nextPage:Bool), LinksOutput> {
  
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
            
            let currentCount = loadedContent?.currentContent.count ?? 0
            page = UInt(currentCount) / pageCount
            
        } else {
            return SignalProducer.empty
        }
        
        let currentContent = (links:[MZMozscapeLinks](), moreAvailable:true)
        return apiManager.linksForString(url, page: page, count: pageCount)
            .scan(loadedContent ?? currentContent) {
                
                let aggregatedLinks = $0.currentContent + $1
                let moreAvailable = UInt($1.count) == self.pageCount
                
                return (links: aggregatedLinks, moreAvailable: moreAvailable )
        }
    }
}
 */