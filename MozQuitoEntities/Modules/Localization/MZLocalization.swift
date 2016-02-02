//
//  CCLocalization.swift
//  MozQuitoEntities
//
//  Created by Josh Campion on 01/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import SwiftInPractice

public enum MZLocalizationKey: String {
    
    // -- URL Info
    
    case URLDataSearchHint
    
    // -- Page Meta Data
    
    case URLPageMetaDataPageTitle
    case URLPageMetaDataCanonicalURL
    case URLPageMetaDataMetaDescription
    case URLPageMetaDataH1Tags
    case URLPageMetaDataH2Tags
    case URLPageMetaDataUsingSSL
    
    // -- Mozscape Data
    
    case URLMozscapeAuthorityTitle
    case URLMozscapeAuthorityPage
    case URLMozscapeAuthorityDomain
    case URLMozscapeAuthoritySpamScore
    case URLMozscapeAuthorityInfo
    
    case URLMozscapeLinksTitle
    case URLMozscapeLinksRootDomain
    case URLMozscapeLinksTotalLinks
    case URLMozscapeLinksInfo
    
    case URLMozscapeLastIndexedTitle
    case URLMozscapeNextIndexedTitle
    
    // -- Alexa Data
    
    static var allValues:[MZLocalizationKey] = [
    
    // -- URL Info
    .URLDataSearchHint,
    
    // -- Page Meta Data
    
    .URLPageMetaDataPageTitle,
    .URLPageMetaDataCanonicalURL,
    .URLPageMetaDataMetaDescription,
    .URLPageMetaDataH1Tags,
    .URLPageMetaDataH2Tags,
    .URLPageMetaDataUsingSSL,
    
    // -- Mozscape Data
    
    .URLMozscapeAuthorityTitle,
    .URLMozscapeAuthorityPage,
    .URLMozscapeAuthorityDomain,
    .URLMozscapeAuthoritySpamScore,
    .URLMozscapeAuthorityInfo,
    
    .URLMozscapeLinksTitle,
    .URLMozscapeLinksRootDomain,
    .URLMozscapeLinksTotalLinks,
    .URLMozscapeLinksInfo,
    
    .URLMozscapeLastIndexedTitle,
    .URLMozscapeNextIndexedTitle
    
    // -- Alexa Data

    
    ]
}

public struct MZLocalization: LocalizationHandler {
    
    public typealias KeyType = MZLocalizationKey
    
    public static let localStrings:[KeyType: (value:String, comment:String)]? = nil
    
    public static var allKeys:[KeyType]? {
        return MZLocalizationKey.allValues
    }
    
    public static func localizationForKey(key:KeyType) -> (value:String, comment:String) {
        switch (key) {
        case .URLDataSearchHint:
            return ("Get Metrics for...", "The text field hint on the URL Data page.")
        case .URLPageMetaDataPageTitle:
            return ("Page Title", "The title on the meta data panel for the page title")
        case .URLPageMetaDataCanonicalURL:
            return ("Canonincal URL", "The title on the meta data panel for the canonical url")
        case .URLPageMetaDataMetaDescription:
            return ("Meta Description", "The title on the meta data panel for the page description")
        case .URLPageMetaDataH1Tags:
            return ("H1", "The title on the meta data panel for the h1 tag elements")
        case .URLPageMetaDataH2Tags:
            return ("H2", "The title on the meta data panel for the h2 tag elements")
        case .URLPageMetaDataUsingSSL:
            return ("Using SSL", "The title on the meta data panel for whether the site is using SSL")
        case .URLMozscapeAuthorityTitle:
            return ("Authority", "The title for the Authroity section of the Mozscape panel")
        case .URLMozscapeAuthorityPage:
            return ("Page Authority", "The subtitle for the mozscape page authority")
        case .URLMozscapeAuthorityDomain:
            return ("Domain Authorith", "The subtitle for the mozscape domain authority")
        case .URLMozscapeAuthoritySpamScore:
            return ("Spam Score", "The subtitle for the mozscape spam score")
        case .URLMozscapeAuthorityInfo:
            return ("<#value#>", "The help info shown for the authority section of the mozscape panel")
        case .URLMozscapeLinksTitle:
            return ("Established Links", "The title for the Links section of the mozscape panel")
        case .URLMozscapeLinksRootDomain:
            return ("Root Domains", "The subtitle for the number of Root Domains in the links section of the mozscape panel")
        case .URLMozscapeLinksTotalLinks: 
            return ("Total Links", "The subtitle for the total number of links in the links section of the mozscape panel")
        case .URLMozscapeLinksInfo: 
            return ("<#value#>", "The help info shown for the links section of the mozscape panel")
        case .URLMozscapeLastIndexedTitle: 
            return ("Last Indexed", "The subtitle of the last index date on the mozscape panel")
        case .URLMozscapeNextIndexedTitle: 
            return ("Next Indexing", "The subtitle of the next index date on the mozscape panel")
        }
    }
}