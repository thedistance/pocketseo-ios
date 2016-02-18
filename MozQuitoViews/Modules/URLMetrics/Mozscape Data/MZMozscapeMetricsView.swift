//
//  MZMozscapeMetricsView.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import StackView
import TheDistanceCore

public class MZMozscapeMetricsView: GMDView {

    
    public let dataStack = MZMozscapeMetricsStack()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureHierarchy()
    }
    
    func configureHierarchy() {
        
        dataStack.stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dataStack.stackView)
        addConstraints(NSLayoutConstraint.constraintsToAlign(view: dataStack.stackView, to: self, withInsets: UIEdgeInsetsMakeEqual(8.0)))
        
        dataStack.expandButton.addTarget(self, action: "expandTapped:", forControlEvents: .TouchUpInside)
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    func expandTapped(sender:UIButton) {
        
        //         UIView.animateWithDuration(0.35, animations: { () -> Void in
        self.dataStack.toggleExpanded()
        self.layoutIfNeeded()
        //         })
    }
    
    
}
