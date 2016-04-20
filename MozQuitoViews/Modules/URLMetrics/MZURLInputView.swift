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
    public let urlSearchBar = UISearchBar()
    public let refreshButton = ThemeButton()
    public let filterButton = ThemeButton()
    
    init() {
        
        let bundle = NSBundle(forClass: MZURLInputStack.self)
        let safariImage = UIImage(named: "ic_open_in_browser", inBundle: bundle, compatibleWithTraitCollection: nil)
        let refreshImage = UIImage(named: "ic_refresh", inBundle: bundle, compatibleWithTraitCollection: nil)
        let filterImage = UIImage(named: "ic_filter_list", inBundle: bundle, compatibleWithTraitCollection: nil)
        
        safariButton.tintColourStyle = .LightText
        safariButton.setImage(safariImage, forState: .Normal)
        safariButton.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        safariButton.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        safariButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        safariButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        
        urlSearchBar.keyboardType = .URL
        urlSearchBar.returnKeyType = .Send
        urlSearchBar.autocapitalizationType = .None
        urlSearchBar.autocorrectionType = .No
        urlSearchBar.placeholder = LocalizedString(.URLDataSearchHint)
        urlSearchBar.barTintColor = MZThemeVendor.defaultColour(.Main)
        urlSearchBar.backgroundImage = UIImage()
        
        
        refreshButton.setImage(refreshImage, forState: .Normal)
        refreshButton.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        refreshButton.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        refreshButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        refreshButton.tintColourStyle = .LightText
        refreshButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12)
        
        filterButton.setImage(filterImage, forState: .Normal)
        filterButton.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        filterButton.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        filterButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        filterButton.tintColourStyle = .LightText
        filterButton.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 12)

        super.init(arrangedSubviews: [urlSearchBar, safariButton, filterButton, refreshButton])
        
        stack.stackDistribution = .Fill
        stack.spacing = 0.0
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
        
        addConstraints(NSLayoutConstraint.constraintsToAlign(view: inputStack.stackView, to: self, withInsets:UIEdgeInsetsZero))
    }
}

