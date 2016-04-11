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
    
    case PageAuthority
    case DomainAuthority
    case SpamScore
    
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

    static var allValues:[LinkSortBy] {
        return [.PageAuthority, .DomainAuthority, .SpamScore]
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
    
    case Page
    case Subdomain
    case Domain
    
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
    
    case All
    case External
    case Internal
    
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
    
    case All
    case Equity
    case NoEquity
    case Follow
    case NoFollow
    case Redirect301
    case Redirect302
    
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
    return true
}