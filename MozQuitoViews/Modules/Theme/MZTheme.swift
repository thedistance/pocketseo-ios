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

/*
@IBDesignable
public class ThemeView: TKView, IBThemeable { }

// --- Text Elements --- \\

@IBDesignable
public class ThemeLabel: TKLabel, IBThemeable { }

@IBDesignable
public class ThemeTextField: TKTextField, IBThemeable { }

@IBDesignable
public class ThemeTextView: TKTextView, IBThemeable { }

// --- Controls --- \\

@IBDesignable
public class ThemeButton: TKButton, IBThemeable { }

@IBDesignable
public class ThemeSwitch: TKSwitch, IBThemeable { }

@IBDesignable
public class ThemeSegmentedControl: TKSegmentedControl, IBThemeable { }

@IBDesignable
public class ThemeStepper: TKStepper, IBThemeable { }

// --- Navigation --- \\

@IBDesignable
public class ThemeNavigationBar: TKNavigationBar, IBThemeable { }

@IBDesignable
public class ThemeBarButtonItem: TKBarButtonItem, IBThemeable { }

@IBDesignable
public class ThemeTabBar: TKTabBar, IBThemeable { }

@IBDesignable
public class ThemeTabBarItem: TKTabBarItem, IBThemeable { }
*/

public class MZThemeVendor: TKThemeVendor {
    
    private var _defaultTheme:Theme? = MZTheme()
    
    public override var defaultTheme:Theme? {
        get {
            return _defaultTheme
        }
        set {
            _defaultTheme = newValue
        }
    }
}

extension TKThemeVendor {
    
    override public class func initialize() {
        super.initialize()
        
        if self == TKThemeVendor.self {
            assert(MZThemeVendor.shared().defaultTheme != nil)
        }
    }
}

public struct MZTheme: Theme {
    
    public init() {}
    
    //    typealias TextStyleType = TextStyle // default
    //    typealias ColourStyleType = ColourStyle // default
    
    let thinFont = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1).fontName
    let normalFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody).fontName
    let mediumFont = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).fontName
    
    public let defaultTextSizes = MaterialTextSizes // default
    public let textSizeAdjustments = AppleFontAdjustments // default
    
    public let themeColours = MZColours
    
    public func fontName(textStye:TextStyle) -> String {
        
        switch textStye {
        case .Display4:
            return thinFont
        case .Display3, .Display2, .Display1, .Headline:
            return normalFont
        case .Title:
            return mediumFont
        case .SubHeadline:
            return normalFont
        case .Body2, .Button:
            return mediumFont
        case .Body1, .Custom(_):
            return normalFont
        case .Caption:
            return thinFont
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
