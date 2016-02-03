//
//  MZTextFieldStack.swift
//  MozQuito
//
//  Created by Josh Campion on 02/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import StackView
import ThemeKit

public class ThemeTextFieldStack: TextFieldStack {
    
    public init() {
        super.init(textField: ThemeTextField(),
            placeholderLabel: ThemeLabel(),
            errorLabel: ThemeLabel(),
            errorImageView: UIImageView(),
            iconImageView: UIImageView(),
            underline: ThemeView())
        
        (textField as? ThemeTextField)?.textColourStyle = .LightText
        (textField as? ThemeTextField)?.placeholderTextColourStyle = .SecondaryText
        (textField as? ThemeTextField)?.textStyle = .Body1
        (textField as? ThemeTextField)?.textInsets = UIEdgeInsetsMake(0, 0, 8, 0)
        (textField as? ThemeTextField)?.tintColor = TKThemeVendor.shared().defaultTheme?.colour(.Accent)
        
        (placeholderLabel as? ThemeLabel)?.textColourStyle = .SecondaryLightText
        (placeholderLabel as? ThemeLabel)?.textStyle = .Caption
        
        (underline as? ThemeView)?.backgroundColourStyle = .SecondaryLightText
    }

    override public func configureUnderline() {
        
        if textField.isFirstResponder() {
            
            underline.alpha = 1.0
            (underline as? ThemeView)?.backgroundColourStyle = .Accent
            
        } else if textField.enabled {
            
            (underline as? ThemeView)?.backgroundColourStyle = .SecondaryLightText
            underline.alpha = 1.0
            
        } else {
            underline.alpha = 0.0
        }
    }

}


