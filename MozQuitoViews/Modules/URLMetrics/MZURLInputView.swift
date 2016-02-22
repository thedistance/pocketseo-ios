//
//  MZURLInputView.swift
//  MozQuito
//
//  Created by Josh Campion on 03/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView
import JCLocalization
import TheDistanceCore

public class MZURLInputStack: CreatedStack {
    
    public let safariButton = ThemeButton()
    public let urlTextFieldStack = ThemeTextFieldStack()
    public let refreshButton = ThemeButton()
    
    init() {
        
        let bundle = NSBundle(forClass: MZURLInputStack.self)
        let safariImage = UIImage(named: "launch_safari", inBundle: bundle, compatibleWithTraitCollection: nil)
        let refreshImage = UIImage(named: "ic_refresh", inBundle: bundle, compatibleWithTraitCollection: nil)
        
        safariButton.tintColourStyle = .LightText
        safariButton.setImage(safariImage, forState: .Normal)
        safariButton.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        safariButton.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        safariButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        
        
        urlTextFieldStack.textField.keyboardType = .URL
        urlTextFieldStack.textField.returnKeyType = .Send
        urlTextFieldStack.textField.autocapitalizationType = .None
        urlTextFieldStack.textField.autocorrectionType = .No
        urlTextFieldStack.placeholderText = LocalizedString(.URLDataSearchHint)
        (urlTextFieldStack.textField as? ThemeTextField)?.textStyle = .SubHeadline
        (urlTextFieldStack.textField as? ThemeTextField)?.textColourStyle = .LightText
        (urlTextFieldStack.textField as? ThemeTextField)?.placeholderTextColourStyle = .SecondaryLightText
        
        refreshButton.setImage(refreshImage, forState: .Normal)
        refreshButton.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        refreshButton.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        refreshButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        refreshButton.tintColourStyle = .LightText
        
        super.init(arrangedSubviews: [urlTextFieldStack.stackView, safariButton, refreshButton])
        
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

