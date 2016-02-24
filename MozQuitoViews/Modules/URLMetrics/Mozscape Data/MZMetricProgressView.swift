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

    func setDValue(d:Double?) {
        if let val = d {
            value = CGFloat(val)
            if let v = value, let t = total {
                progressView.setProgress(v / t, animated: false)
            }
        } else {
            value = nil
        }
    }
    
    public var value:CGFloat? {
        didSet {
            if let v = value {
                valueLabel.text = String(Int(round(v)))
            } else {
                valueLabel.text = NoValueString
            }
        }
    }
    
    public var total:CGFloat? {
        didSet {
            if let t = total {
                totalLabel.text = String(Int(t))
            } else {
                totalLabel.text = NoValueString
            }
        }
    }
    
    let valueStack = GenericStringsStack<ThemeLabel>(strings: [NoValueString, ""])
    var valueLabel:ThemeLabel {
        return valueStack.labels[0]
    }
    
    var totalLabel:ThemeLabel {
        return valueStack.labels[1]
    }
    
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
        
        progressView.showPercentage = false
        progressView.backgroundRingWidth = 4.0
        progressView.progressRingWidth = 4.0
        progressView.secondaryColor = UIColor(white: 0.8, alpha: 1.0)
        progressView.primaryColor = MZThemeVendor.defaultColour(.Main)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        valueStack.stackView.translatesAutoresizingMaskIntoConstraints = false
        valueStack.stack.spacing = -2.0
        
        valueLabel.textStyle = .Display1
        valueLabel.textAlignment = .Center
        
        totalLabel.textStyle = .Caption
        totalLabel.textAlignment = .Center
        
        addSubview(progressView)
        addSubview(valueStack.stackView)
        
        progressView.addConstraint(NSLayoutConstraint.constraintToSizeView(progressView, toRatio: 1))
        
        addConstraints(NSLayoutConstraint.constraintsToAlign(view: progressView, to: self))
        
        let valueView = valueStack.stackView
        
        let centerConstrs = [
            
            NSLayoutConstraint(item: valueView,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: self,
                attribute: .CenterX,
                multiplier: 1.0,
                constant: 0.0),
            
            NSLayoutConstraint(item: valueView,
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
                toItem: valueView,
                attribute: .Width,
                multiplier: 1.25,
                constant: 0.0),
        
            NSLayoutConstraint(item: self,
                attribute: .Height,
                relatedBy: .GreaterThanOrEqual,
                toItem: valueView,
                attribute: .Height,
                multiplier: 1.25,
                constant: 0.0)
        ]
        
        addConstraints(sizeConstrs)
        addConstraints(centerConstrs)
    }
}
