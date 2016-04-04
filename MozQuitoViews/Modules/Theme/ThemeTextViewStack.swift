//
//  MZTextFieldStack.swift
//  MozQuito
//
//  Created by Josh Campion on 02/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import StackView
import ThemeKitCore

class ThemeTextViewStack: TextViewStack {
    
    init() {
        super.init(textView: ThemeTextView(),
            placeholderLabel: ThemeLabel(),
            errorLabel: ThemeLabel(),
            errorImageView: UIImageView(),
            iconImageView: UIImageView(),
            underline: ThemeView())
        
        (textView as? ThemeTextView)?.textColourStyle = .Text
        (textView as? ThemeTextView)?.textStyle = .Body1
        (textView as? ThemeTextView)?.tintColor = TKThemeVendor.shared().defaultTheme?.colour(.Accent)
        
        (placeholderLabel as? ThemeLabel)?.textColourStyle = .Accent
        (placeholderLabel as? ThemeLabel)?.textStyle = .Caption
        
        (underline as? ThemeView)?.backgroundColourStyle = .SecondaryText
    }

    override func configureUnderline() {
        
        if textView.isFirstResponder() {
            
            underline.alpha = 1.0
            (underline as? ThemeView)?.backgroundColourStyle = .Accent
            
        } else if textView.userInteractionEnabled {
            
            (underline as? ThemeView)?.backgroundColourStyle = .SecondaryText
            underline.alpha = 1.0
            
        } else {
            underline.alpha = 0.0
        }
    }

}


