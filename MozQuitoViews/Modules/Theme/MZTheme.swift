//
//  CCTheme.swift
//  Close Call Capture
//
//  Created by Josh Campion on 01/02/2016.
//  Copyright © 2016 Virgin Trains East Cost. All rights reserved.
//

import Foundation
import ThemeKit

import UIKit
import ThemeKit

public extension IBThemeable {
    
    public func ibTheme() -> Theme? {
        return CCTheme()
    }
}

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

public class CCThemeVendor: TKThemeVendor {
    
    private var _defaultTheme:Theme? = CCTheme()
    
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
            assert(CCThemeVendor.shared().defaultTheme != nil)
        }
    }
}

public struct CCTheme: Theme {
    
    public init() {}
    
    //    typealias TextStyleType = TextStyle // default
    //    typealias ColourStyleType = ColourStyle // default
    
    public let defaultTextSizes = MaterialTextSizes // default
    public let textSizeAdjustments = AppleFontAdjustments // default
    
    public let themeColours = MaterialColours
    
    public func fontName(textStye:TextStyle) -> String {
        
        switch textStye {
        case .Display4:
            return "HelveticaNeue-Light"
        case .Display3, .Display2, .Display1, .Headline, .SubHeadline, .Body1, .Caption:
            return "HelveticaNeue"
        case .Title, .Body2, .Button:
            return "HelveticaNeue-Medium"
        }
    }
}

let MaterialColours:[ColourStyle:UIColor] = [
//    .Accent: UIColor.redColor(),
    .Main: UIColor(red: 219.0 / 255.0, green: 0, blue: 19.0 / 255.0, alpha: 1.0),
    .MainDark: UIColor(red: 181.0 / 255.0, green: 0, blue: 20.0 / 255.0, alpha: 1.0),
    .Text: UIColor.blackColor().colorWithAlphaComponent(0.87),
    .SecondaryText: UIColor.blackColor().colorWithAlphaComponent(0.54),
    .LightText: UIColor.whiteColor().colorWithAlphaComponent(0.87),
    .SecondaryLightText: UIColor.whiteColor().colorWithAlphaComponent(0.54)
]
