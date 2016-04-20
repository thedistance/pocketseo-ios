//
//  MZDistanceViews.swift
//  MozQuito
//
//  Created by Josh Campion on 29/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import StackView

class MZDistanceView: MZPanel {
    
    var distanceStack:MZDistanceStack? {
        willSet {
            if let s = distanceStack {
                s.stackView.removeFromSuperview()
            }
        }
        didSet {
            configureHierarchy()
        }
    }
    
    override var stack:CreatedStack? {
        get {
            return distanceStack
        }
        set {
            if let distanceStack = stack as? MZDistanceStack {
                self.distanceStack = distanceStack
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureStackAxis()
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        configureStackAxis()
    }
    
    func configureStackAxis() {
        
        guard let distanceStack = self.distanceStack else { return }
        
        let isCompact = traitCollection.horizontalSizeClass == .Compact
        
        let newAxis:UILayoutConstraintAxis = isCompact ? .Vertical : .Horizontal
        
        // dispatch to main queue as editing both at once doesn't work...
        if distanceStack.headingStack.axis != newAxis {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                distanceStack.headingStack.axis = newAxis
                self.setNeedsLayout()
            })
        }
    }
}

