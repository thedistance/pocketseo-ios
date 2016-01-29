//
//  MZMetricProgressView.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import StackView
import M13ProgressSuite

public class MZMetricProgressView: UIView {

    public var value:CGFloat?
    public var total:CGFloat?
    
    let valueStack = GenericStringsStack<UILabel>(strings: ["", ""])
    let progressView = M13ProgressViewRing()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureViews()
    }
    
    func configureViews() {
        
        self.backgroundColor = UIColor.clearColor()
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        valueStack.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(progressView)
        addSubview(valueStack.stackView)
        
        progressView.addConstraint(NSLayoutConstraint.constraintToSizeView(progressView, toRatio: 1))
        
        addConstraints(NSLayoutConstraint.constraintsToAlign(view: progressView, to: self))
        
        let centerConstrs = [
            
            NSLayoutConstraint(item: valueStack,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(item: valueStack,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterY,
                multiplier: 1.0,
                constant: 0.0)
        ]
        
        let sizeConstrs = [
        
            NSLayoutConstraint(item: self,
                attribute: .Width,
                relatedBy: .GreaterThanOrEqual,
                toItem: valueStack,
                attribute: .Width,
                multiplier: 2.0,
                constant: 0.0),
        
            NSLayoutConstraint(item: self,
                attribute: .Height,
                relatedBy: .GreaterThanOrEqual,
                toItem: valueStack,
                attribute: .Height,
                multiplier: 2.0,
                constant: 0.0)
        ]
        
        addConstraints(sizeConstrs)
        addConstraints(centerConstrs)
    }
}
