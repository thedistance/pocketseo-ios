//
//  MZExpandingStack.swift
//  MozQuito
//
//  Created by Josh Campion on 24/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView
import TheDistanceCore

public class MZExpandingStack: CreatedStack {
    
    let loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    let errorStack = ErrorStack(message: "")
    
    let expandButton = ThemeButton(type: .System)
    private(set) var expandTarget:ObjectTarget<UIButton>?
    
    private(set) var expandingTitleStack:StackView
    private(set) var expanded:Bool = false
    
    init(titleView:UIView, arrangedSubviews:[UIView]) {
        
        loadingView.color = MZThemeVendor.defaultColour(.SecondaryText)
        loadingView.hidden = true
        
        expandingTitleStack = CreateStackView([titleView, expandButton])
        
        var allViews = arrangedSubviews
        allViews.insert(loadingView, atIndex: 0)
        allViews.insert(expandingTitleStack.view, atIndex: 0)
        
        let errorContainer = UIView()
        errorContainer.backgroundColor = UIColor.clearColor()
        errorContainer.addSubview(errorStack.stackView)
        errorContainer.hidden = true
        
        allViews.append(errorContainer)
        
        super.init(arrangedSubviews: allViews)
        
        configureStack()
    }
    
    func configureStack() {
        
        // configure button
        let expandImage = UIImage(named: "ic_expand_more", inBundle: NSBundle(forClass: MZPageMetaDataStack.self), compatibleWithTraitCollection: nil)
        expandButton.setImage(expandImage, forState: .Normal)
        expandButton.tintColourStyle = .SecondaryText
        expandButton.contentHorizontalAlignment = .Left
        expandButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        
        expandTarget = ObjectTarget(control: expandButton, forControlEvents: .TouchUpInside, completion: toggleExpanded)
        
        // configure the title stack
        expandingTitleStack.axis = .Horizontal
        expandingTitleStack.stackAlignment = .Fill
        expandingTitleStack.stackDistribution = .Fill
        expandingTitleStack.spacing = 8.0
        
        self.stack.axis = .Vertical
        self.stack.stackAlignment = .Fill
        self.stack.stackDistribution = .Fill
        self.stack.spacing = 16.0
    }
    
    public func toggleExpanded(sender:AnyObject?) {
        
        self.configureAsExpanded(!self.expanded)
        self.stackView.layoutIfNeeded()
    }
    
    public func configureAsExpanded(expanded:Bool) {
        
        self.expanded = expanded
        
        let pi = CGFloat(M_PI)
        expandButton.transform = expanded ? CGAffineTransformMakeRotation(pi) : CGAffineTransformMakeRotation(2.0 * pi)
    }
}