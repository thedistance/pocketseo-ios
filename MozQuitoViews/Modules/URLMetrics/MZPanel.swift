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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if #available(iOS 9.0, *) { }
        else {
            let width = tdStack.headlineLabel.frame.size.width
            if tdStack.headlineLabel.preferredMaxLayoutWidth != width {
               tdStack.headlineLabel.preferredMaxLayoutWidth = width 
            }
            
        }
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let isCompact = traitCollection.horizontalSizeClass == .Compact
        
        let newAxis:UILayoutConstraintAxis = isCompact ? .Vertical : .Horizontal
        
        // dispatch to main queue as editing both at once doesn't work...
        if tdStack.headingStack.axis != newAxis {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tdStack.headingStack.axis = newAxis
            })
        }
        
        if tdStack.buttonStack.axis != newAxis {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tdStack.buttonStack.axis = newAxis
            })
        }
    }
}

