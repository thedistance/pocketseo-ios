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

public enum PanelState: Equatable {
    
    case Loading
    case Error(NSError)
    case Success
}

public func ==(p1:PanelState, p2:PanelState) -> Bool {
    switch (p1, p2) {
    case (.Loading, .Loading):
        return true
    case (.Success, .Success):
        return true
    case (.Error(let e1), .Error(let e2)):
        return e1.domain == e2.domain && e1.code == e2.code
    default:
        return false
    }
}

public class MZExpandingStack: CreatedStack {
    
    let loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    let errorView = MZErrorView(image:UIImage(named:"Error"), message: "")
    
    let expandButton = ThemeButton(type: .System)
    private(set) var expandTarget:ObjectTarget<UIButton>?
    
    private(set) var expandingTitleStack:StackView
    private(set) var expanded:Bool = false
    
    var state:PanelState = .Loading {
        didSet {
            
            if state != oldValue {
                configureAsExpanded(false)
            }
            
            configureForState(state)
        }
    }
    
    let contentStack:StackView
    let errorContainer = UIView()
    
    init(titleView:UIView, arrangedSubviews:[UIView]) {
        
        loadingView.color = MZThemeVendor.defaultColour(.SecondaryText)
        loadingView.hidesWhenStopped = true
        loadingView.transform = CGAffineTransformMakeScale(0.75, 0.75)
        
        let buttonWidthConstraint = NSLayoutConstraint(item: expandButton,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: 48.0)
        let buttonHeightConstraint = NSLayoutConstraint(item: expandButton,
            attribute: .Height,
            relatedBy: .GreaterThanOrEqual,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 1.0,
            constant: 34.0)
        expandButton.addConstraints([buttonWidthConstraint, buttonHeightConstraint])
        
        expandingTitleStack = CreateStackView([titleView, expandButton])
        contentStack = CreateStackView(arrangedSubviews)
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorContainer.backgroundColor = UIColor.clearColor()
        errorContainer.addSubview(errorView)
        
        let alignConstrs = NSLayoutConstraint.constraintsToAlign(view: errorView, to: errorContainer)
        
        let centerX = NSLayoutConstraint(item: errorView,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: errorContainer,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0.0)
        
        let width = NSLayoutConstraint(item: errorView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: nil,
            attribute: .NotAnAttribute,
            multiplier: 0.0,
            constant: 288.0)
        
        errorContainer.addConstraints([alignConstrs[0], alignConstrs[2], centerX, width])
        errorContainer.hidden = true
        
        super.init(arrangedSubviews: [expandingTitleStack.view, loadingView, contentStack.view, errorContainer])
        
        configureStack()
        configureForState(self.state)
    }
    
    func configureForState(state:PanelState) {
        
        switch state {
        case .Success:
            
            loadingView.stopAnimating()
            expandButton.hidden = false

            contentStack.view.hidden = false
            errorContainer.hidden = true
            
        case .Loading:
            
            loadingView.startAnimating()
            expandButton.hidden = true
            contentStack.view.hidden = true
            errorContainer.hidden = true
            
        case .Error(let error):
            
            loadingView.stopAnimating()
            expandButton.hidden = true
            contentStack.view.hidden = true
            errorContainer.hidden = false
            
            let ufError = error.userFacingError()
            errorView.label.text = [
                ufError.localizedDescription,
                ufError.localizedFailureReason,
                ufError.localizedRecoverySuggestion
                ]
                .flatMap({ $0 })
                .filter({ !$0.isEmpty })
                .joinWithSeparator(" ")
            
        }
    }
    
    func configureStack() {
        
        // configure button
        let expandImage = UIImage(named: "ic_expand_more", inBundle: NSBundle(forClass: MZPageMetaDataStack.self), compatibleWithTraitCollection: nil)
        expandButton.setImage(expandImage, forState: .Normal)
        expandButton.tintColourStyle = .SecondaryText
        expandButton.contentHorizontalAlignment = .Right
        expandButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        
        expandTarget = ObjectTarget(control: expandButton, forControlEvents: .TouchUpInside, completion: toggleExpanded)
        
        // configure the title stack
        expandingTitleStack.axis = .Horizontal
        expandingTitleStack.stackAlignment = .Fill
        expandingTitleStack.stackDistribution = .Fill
        expandingTitleStack.spacing = -48.0
        
        for var s in [stack, contentStack] {
            s.axis = .Vertical
            s.stackAlignment = .Fill
            s.stackDistribution = .Fill
            s.spacing = 16.0
        }
        
    }
    
    public func toggleExpanded(sender:UIButton) {
        
        self.configureAsExpanded(!self.expanded)
//        self.stackView.layoutIfNeeded()
    }
    
    public func configureAsExpanded(expanded:Bool) {
        
        self.expanded = expanded
        
        let pi = CGFloat(M_PI)
        expandButton.imageView?.transform = expanded ? CGAffineTransformMakeRotation(pi) : CGAffineTransformMakeRotation(2.0 * pi)
    }
}