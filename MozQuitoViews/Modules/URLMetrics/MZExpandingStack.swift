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
    let errorStack = ErrorStack(message: "")
    
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
        
        expandingTitleStack = CreateStackView([titleView, expandButton])
        contentStack = CreateStackView(arrangedSubviews)
        
        errorContainer.backgroundColor = UIColor.clearColor()
        errorContainer.addSubview(errorStack.stackView)
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
            errorStack.message = [
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
        expandButton.contentHorizontalAlignment = .Left
        expandButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        
        expandTarget = ObjectTarget(control: expandButton, forControlEvents: .TouchUpInside, completion: toggleExpanded)
        
        // configure the title stack
        expandingTitleStack.axis = .Horizontal
        expandingTitleStack.stackAlignment = .Fill
        expandingTitleStack.stackDistribution = .Fill
        expandingTitleStack.spacing = 8.0
        
        for var s in [stack, contentStack] {
            s.axis = .Vertical
            s.stackAlignment = .Fill
            s.stackDistribution = .Fill
            s.spacing = 16.0
        }
        
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