//
//  MZLinksConfiguration.swift
//  MozQuito
//
//  Created by Josh Campion on 08/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

public enum LinkSortBy: String {
    
    case PageAuthority = "page_authority"
    case DomainAuthority = "domain_authority"
    case SpamScore = "spam_score"
    
}

public enum LinkTarget: String {
    
    case Page = "page_to_page"
    case Subdomain = "page_to_subdomain"
    case Domain = "page_to_domain"
    
}

public enum LinkSource: String {
    
    case All = ""
    case External = "external"
    case Internal = "internal"
    
}

public enum LinkType: String {
    
    case All = ""
    case Equity = "equity"
    case NoEquity = "noequity"
    case Follow = "follow"
    case NoFollow = "nofollow"
    case Redirect301 = "301"
    case Redirect302 = "302"
    
}

struct LinkSearchConfiguration: Equatable {
    
    static func defaultConfiguration() -> LinkSearchConfiguration {
        return LinkSearchConfiguration(sortBy: .PageAuthority, target: .Page, source: .All, type: .All, targetCols: "4", limit: "25")
    }
    
    static func distanceLinkSortyByDA() -> LinkSearchConfiguration {
        return LinkSearchConfiguration(sortBy: .DomainAuthority, target: .Page, source: .All, type: .All, targetCols: "4", limit: "25")
    }
    
    static func distanceLinkFilterByTypeAndSource() -> LinkSearchConfiguration {
        return LinkSearchConfiguration(sortBy: .PageAuthority, target: .Page, source: .External, type: .All, targetCols: "4", limit: "25")
    }
    
    let sortBy: LinkSortBy
    let target: LinkTarget
    let source: LinkSource
    let type: LinkType
    
    //standard parameters for each call
    let targetCols: String
    let limit: String
    
    var mozscapeRequestParameters:[String:String] {
        
        var params = [String:String]()
        
        params["Sort"] = sortBy.rawValue
        
        params["Scope"] = target.rawValue
        
        params["TargetCols"] = targetCols
        
        params["Limit"] = limit
        
        switch (source, type) {
        case (.All, .All):
            // add no filter
            break
        case (.All, _):
            // only
            params["Filter"] = type.rawValue
        case (_, .All):
            params["Filter"] = source.rawValue
        default:
            params["Filter"] = "\(type.rawValue)+\(source.rawValue)"
        }
        
        return params
    }
    
}

func ==(c1:LinkSearchConfiguration, c2:LinkSearchConfiguration) -> Bool {
    return true
}