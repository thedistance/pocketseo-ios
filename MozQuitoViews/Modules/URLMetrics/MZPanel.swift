//
//  MZPanel.swift
//  MozQuito
//
//  Created by Josh Campion on 24/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import StackView
import TheDistanceCore

public class MZPanel: GMDView {
    
    public private(set) var stack:CreatedStack?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureHierarchy()
    }
    
    func configureHierarchy() {
        
        self.backgroundColor = UIColor.whiteColor()
        
        guard let stack = self.stack else { return }
        
        stack.stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack.stackView)
        addConstraints(NSLayoutConstraint.constraintsToAlign(view: stack.stackView, to: self, withInsets: UIEdgeInsetsZero, relativeToMargin: (true,true,true,true)))
    }
    
    override public func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let isCompact = traitCollection.horizontalSizeClass == .Compact
        self.layoutMargins = isCompact ? UIEdgeInsetsMakeEqual(8.0) : UIEdgeInsetsMakeEqual(20.0)
        
    }
}

// MARK: - Panel Subclasses

public class MZPageMetaDataView: MZPanel {
    
    public let metaStack = MZPageMetaDataStack()
    
    override public var stack:CreatedStack? {
        get {
            return metaStack
        }
        set { }
    }
}

public class MZMozscapeMetricsView: MZPanel {
    
    public let dataStack = MZMozscapeMetricsStack()
    
    override public var stack:CreatedStack? {
        get {
            return dataStack
        }
        set { }
    }
}

public class MZAlexaDataView: MZPanel {
    
    let dataStack = MZAlexaDataStack()
    
    override public var stack:CreatedStack? {
        get {
            return dataStack
        }
        set { }
    }
}

class MZDistanceView: MZPanel {
    
    private(set) var tdStack = MZDistanceStack()
    
    override var stack:CreatedStack? {
        get {
            return tdStack
        }
        set { }
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let isCompact = traitCollection.horizontalSizeClass == .Compact
        
        let newAxis:UILayoutConstraintAxis = isCompact ? .Vertical : .Horizontal
        if tdStack.buttonStack.axis != newAxis {
            tdStack.buttonStack.axis = newAxis
        }
        
        if tdStack.headingStack.axis != newAxis {
            tdStack.headingStack.axis = newAxis
        }
    }
}

