//
//  MZLinksConfiguration.swift
//  MozQuito
//
//  Created by Josh Campion on 08/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import JCLocalization

public enum LinkSortBy: String {
    
    static var titleKey:LocalizationKey = .LinksFilterSortBy
    
    case PageAuthority = "page_authority"
    case DomainAuthority = "domain_authority"
    case SpamScore = "spam_score"
    
    var localizationKey:LocalizationKey {
        switch self {
        case .PageAuthority:
            return .LinksFilterPageAuthority
        case .DomainAuthority:
            return .LinksFilterDomainAuthority
        case .SpamScore:
            return .LinksFilterSpamScore
        }
    }
    
//    static var allValues:[LinkSortBy] {
//        return [.DomainAuthority, .PageAuthority, .SpamScore]
//    }
    
    static var paidValues:[LinkSortBy] {
        return [.DomainAuthority, .PageAuthority, .SpamScore]
    }
    
    static var freeValues:[LinkSortBy] {
        return [.DomainAuthority, .PageAuthority]
    }
    
    var selectionKey:String {
        return "Sort_" + rawValue
    }
    
    init?(selectionKey:String) {
        if let r = selectionKey.rangeOfString("Sort_") {
            self.init(rawValue: selectionKey.substringFromIndex(r.endIndex))
        } else {
            return nil
        }
    }
}

public enum LinkTarget: String {
    
    static var titleKey:LocalizationKey = .LinksFilterTarget
    
    case Page = "page_to_page"
    case Subdomain = "page_to_subdomain"
    case Domain = "page_to_domain"
    
    var localizationKey:LocalizationKey {
        switch self {
        case .Page:
            return .LinksFilterPage
        case .Subdomain:
            return .LinksFilterSubdomain
        case .Domain:
            return .LinksFilterDomain
        }
    }
    
    static var allValues:[LinkTarget] {
        return [.Page, .Subdomain, .Domain]
    }
    
//    static var freeValues:[LinkTarget] {
//        return [.Page, .Subdomain, .Domain]
//    }
//    
//    static var paidValues:[LinkTarget] {
//        return [.Page, .Subdomain, .Domain]
//    }
    
    var selectionKey:String {
        return "Target_" + rawValue
    }
    
    init?(selectionKey:String) {
        if let r = selectionKey.rangeOfString("Target_") {
            self.init(rawValue: selectionKey.substringFromIndex(r.endIndex))
        } else {
            return nil
        }
    }
}

public enum LinkSource: String {
    
    static var titleKey:LocalizationKey = .LinksFilterSource
    
    case All = ""
    case External = "external"
    case Internal = "internal"
    
    var localizationKey:LocalizationKey {
        switch self {
        case .All:
            return .LinksFilterAll
        case .External:
            return .LinksFilterExternal
        case .Internal:
            return .LinksFilterInternal
        }
    }
    
    static var allValues:[LinkSource] {
        return [.All, .External, .Internal]
    }
    
    var selectionKey:String {
        return "Source_" + rawValue
    }
    
    init?(selectionKey:String) {
        if let r = selectionKey.rangeOfString("Source_") {
            self.init(rawValue: selectionKey.substringFromIndex(r.endIndex))
        } else {
            return nil
        }
    }
}

public enum LinkType: String {
    
    static var titleKey:LocalizationKey = .LinksFilterLinkType
    
    case All = ""
    case Equity = "equity"
    case NoEquity = "nonequity"
    case Follow = "follow"
    case NoFollow = "nofollow"
    case Redirect301 = "301"
    case Redirect302 = "302"
    
    var localizationKey:LocalizationKey {
        switch self {
        case .All:
            return .LinksFilterAll
        case .Equity:
            return .LinksFilterEquity
        case .NoEquity:
            return .LinksFilterNoEquity
        case .Follow:
            return .LinksFilterFollow
        case .NoFollow:
            return .LinksFilterNoFollow
        case .Redirect301:
            return .LinksFilter301
        case .Redirect302:
            return .LinksFilter302
        }
    }
    
    static var allValues:[LinkType] {
        return [.All, .Equity, .NoEquity, .Follow, .NoFollow, .Redirect301, .Redirect302]
    }
    
    var selectionKey:String {
        return "Type_" + rawValue
    }
    
    init?(selectionKey:String) {
        if let r = selectionKey.rangeOfString("Type_") {
            self.init(rawValue: selectionKey.substringFromIndex(r.endIndex))
        } else {
            return nil
        }
    }
}

struct LinkSearchConfiguration: Equatable {
    
    static func defaultConfiguration() -> LinkSearchConfiguration {
        return LinkSearchConfiguration(sortBy: .DomainAuthority, target: .Page, source: .All, type: .All)
    }
    
    static func distanceLinkSortyByDA() -> LinkSearchConfiguration {
        return LinkSearchConfiguration(sortBy: .DomainAuthority, target: .Page, source: .All, type: .All)
    }
    
    static func distanceLinkFilterByTypeAndSource() -> LinkSearchConfiguration {
        return LinkSearchConfiguration(sortBy: .PageAuthority, target: .Page, source: .External, type: .All)
    }
    
    let sortBy: LinkSortBy
    let target: LinkTarget
    let source: LinkSource
    let type: LinkType
    
    //standard parameters for each call
    let targetCols: String
    let limit: String
    
    init(sortBy: LinkSortBy, target: LinkTarget, source: LinkSource, type: LinkType, targetCols: String = "4", limit: String = "25") {
        
        self.sortBy = sortBy
        self.source = source
        self.target = target
        self.type = type
        
        self.targetCols = targetCols
        self.limit = limit
    }
    
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
    
    var selectionKeys:[String] {
        return [
            sortBy.selectionKey,
            target.selectionKey,
            source.selectionKey,
            type.selectionKey
        ]
    }
}

extension LinkSearchConfiguration {
    init?(selectionKeys:[String]) {
        
        var sort:LinkSortBy? = nil
        var source:LinkSource? = nil
        var target:LinkTarget? = nil
        var type:LinkType? = nil
        
        for k in selectionKeys {
            if let s = LinkSortBy(selectionKey: k) {
                sort = s
            } else if let s = LinkSource(selectionKey: k) {
                source = s
            } else if let t = LinkTarget(selectionKey: k) {
                target = t
            } else if let t = LinkType(selectionKey: k) {
                type = t
            }
        }
        
        if let srt = sort,
            let src = source,
            let tgt = target,
            let typ = type {
            self.init(sortBy: srt, target: tgt, source: src, type: typ)
        } else {
            return nil
        }
        
    }
}

func ==(c1:LinkSearchConfiguration, c2:LinkSearchConfiguration) -> Bool {
    return c1.sortBy == c2.sortBy &&
        c1.target == c2.target &&
        c1.source == c2.source &&
        c1.type == c2.type &&
        c1.targetCols == c2.targetCols &&
        c1.limit == c2.limit
}