//
//  MZURLInputView.swift
//  MozQuito
//
//  Created by Josh Campion on 03/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView
import ThemeKit
import PocketSEOEntities
import TheDistanceCore

public class MZURLInputStack: CreatedStack {
    
    public let safariButton = ThemeButton()
    public let urlTextFieldStack = ThemeTextFieldStack()
    public let refreshButton = ThemeButton()
    
    init() {
        
        safariButton.tintColourStyle = .LightText
        safariButton.setImage(UIImage(named: "launch_safari"), forState: .Normal)
        safariButton.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        safariButton.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        safariButton.setContentHuggingPriority(255, forAxis: .Horizontal)
//        safariButton.hidden = true
        
        
        urlTextFieldStack.textField.keyboardType = .URL
        urlTextFieldStack.textField.returnKeyType = .Send
        urlTextFieldStack.textField.autocapitalizationType = .None
        urlTextFieldStack.textField.autocorrectionType = .No
        urlTextFieldStack.placeholderText = MZLocalizedString(.URLDataSearchHint)
        (urlTextFieldStack.textField as? ThemeTextField)?.textStyle = .SubHeadline
        (urlTextFieldStack.textField as? ThemeTextField)?.textColourStyle = .LightText
        (urlTextFieldStack.textField as? ThemeTextField)?.placeholderTextColourStyle = .SecondaryLightText
        
        refreshButton.setImage(UIImage(named: "ic_refresh"), forState: .Normal)
        refreshButton.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        refreshButton.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        refreshButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        refreshButton.tintColourStyle = .LightText
        
        super.init(arrangedSubviews: [safariButton, urlTextFieldStack.stackView, refreshButton])
        
        stack.stackDistribution = .Fill
        stack.spacing = 8.0
    }
}

@IBDesignable
public class MZURLInputView: UIView {
    
    public let inputStack = MZURLInputStack()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureHierarchy()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
    }
    
    func configureHierarchy() {
        
        inputStack.stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(inputStack.stackView)
        
        addConstraints(NSLayoutConstraint.constraintsToAlign(view: inputStack.stackView, to: self, withInsets:UIEdgeInsetsMake(16,8,8,8)))
    }
}

