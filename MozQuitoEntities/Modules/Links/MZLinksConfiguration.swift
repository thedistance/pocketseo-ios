//
//  MZLinksConfiguration.swift
//  MozQuito
//
//  Created by Josh Campion on 08/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

public enum LinkSortBy: String {
    
    case PageAuthority = "page"
    case DomainAuthority
    case SpamScore
    
}

public enum LinkTarget: String {
    
    case Page
    case Subdomain
    case Domain
    
}

public enum LinkSource: String {
    
    case All
    case External
    case Internal
    
}

public enum LinkType: String {
    
    case All
    case Equity
    case NoEquity
    case Follow
    case NoFollow
    case Redirect301
    case Redirect302
    
}

struct LinkSearchConfiguration: Equatable {
    
    static func defaultConfiguration() -> LinkSearchConfiguration {
        return LinkSearchConfiguration(sortBy: .PageAuthority, target: .Page, source: .All, type: .All)
    }
    
    let sortBy: LinkSortBy
    let target: LinkTarget
    let source: LinkSource
    let type: LinkType
    
    var mozscapeRequestParameters:[String:String] {
        
        var params = [String:String]()
        
        switch (source, type) {
        case (.All, .All):
            // add no filter
            break
        case (.All, _):
            // only
            params["filter"] = type.rawValue
        case (_, .All):
            params["filter"] = source.rawValue
        default:
            params["filter"] = "\(type.rawValue)+\(source.rawValue)"
        }
        
        return params
    }
    
}

func ==(c1:LinkSearchConfiguration, c2:LinkSearchConfiguration) -> Bool {
    return true
}