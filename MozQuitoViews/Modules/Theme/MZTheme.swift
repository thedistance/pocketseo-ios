//
//  CCTheme.swift
//  Close Call Capture
//
//  Created by Josh Campion on 01/02/2016.
//  Copyright © 2016 Virgin Trains East Cost. All rights reserved.
//

import Foundation
import ThemeKitCore

import UIKit

public extension IBThemeable {
    
    public func ibTheme() -> Theme? {
        return MZTheme()
    }
}

public class MZThemeVendor: TKThemeVendor {
    
    private var _defaultTheme:Theme? = MZTheme()
    
    override init() {
        super.init()
        
        if #available(iOS 9.0, *) {
            UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).font = defaultTheme?.font(.SubHeadline)
            UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = defaultTheme?.colour(.Accent)
            UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = defaultTheme?.colour(.LightText)
        } else {
            // Fallback on earlier versions
            UITextField.my_appearanceWhenContainedIn(UISearchBar.self).font = defaultTheme?.font(.SubHeadline)
            UITextField.my_appearanceWhenContainedIn(UISearchBar.self).tintColor = defaultTheme?.colour(.Accent)
            UIBarButtonItem.my_appearanceWhenContainedIn(UISearchBar.self).tintColor = defaultTheme?.colour(.LightText)
        }
    }
    
    public override var defaultTheme:Theme? {
        get {
            return _defaultTheme
        }
        set {
            _defaultTheme = newValue
        }
    }
}

public struct MZTheme: Theme {
    
    public init() {}
    
    //    typealias TextStyleType = TextStyle // default
    //    typealias ColourStyleType = ColourStyle // default
    
    let thinSFFont = ".SFUIText-Light"// UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline).fontName
    let normalSFFont = ".SFUIText-Regular" //UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontName
    let mediumSFFont = ".SFUIText-Semibold" //UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).fontName
    
    let thinHFont = "HelveticaNeue-Light"// UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline).fontName
    let normalHFont = "HelveticaNeue" //UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontName
    let mediumHFont = "HelveticaNeue-Medium" //UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).fontName
    
    
    public let defaultTextSizes = MaterialTextSizes // default
    public let textSizeAdjustments = AppleFontAdjustments // default
    
    public let themeColours = MZColours
    
    public func fontName(textStye:TextStyle) -> String {
        
        let thinFont:String
        let normalFont:String
        let mediumFont:String
        
        if #available(iOS 9, * ) {
            thinFont = thinSFFont
            normalFont = normalSFFont
            mediumFont = mediumSFFont
        } else {
            thinFont = thinHFont
            normalFont = normalHFont
            mediumFont = mediumHFont
        }
    
        switch textStye {
        case .Display4:
            return thinFont
        case .Display3, .Display2, .Display1:
            return thinFont
        case .Headline:
            return normalFont
        case .Title:
            return mediumFont
        case .SubHeadline:
            return normalFont
        case .Body2, .Button:
            return mediumFont
        case .Body1, .Custom(_):
            return thinFont
        case .Caption:
            return normalFont
        }
    }
}

let MZColours:[ColourStyle:UIColor] = [
    .Main: UIColor(hexString: "0071bc")!,
    .MainDark: UIColor(hexString: "1b1464")!,
    .Accent: UIColor(hexString: "fbb03b")!,
    .Text: UIColor.blackColor().colorWithAlphaComponent(0.87),
    .SecondaryText: UIColor.blackColor().colorWithAlphaComponent(0.54),
    .LightText: UIColor.whiteColor().colorWithAlphaComponent(0.87),
    .SecondaryLightText: UIColor.whiteColor().colorWithAlphaComponent(0.54)
]
