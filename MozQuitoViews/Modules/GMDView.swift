//
//  GMDView.swift
//  GMDViews
//
//  Created by Josh Campion on 04/02/2016.
//  Copyright © Josh Campion. All rights reserved.
//

import Foundation

enum GMDElevation {
    
    case CardRaised
    case Card
    case Button
    case ButtonPressed
    case ButtonDisabled
    
    var shadowRadius:CGFloat {
        
        switch (self) {
        case .CardRaised, .ButtonPressed:
            return 8.0
        case .Card, .Button:
            return 2.0
        case .ButtonDisabled:
            return 0.0
        }
        
    }
}

protocol _GMDView {
    
    var elevation:GMDElevation { get set }
    
    func configureAsGMD()
    
    func configureForElevation(elevation:GMDElevation)
}

extension _GMDView where Self:UIView {
    
    func defaultConfigureAsGMD() {
        self.layer.cornerRadius = 2.0
        self.layer.shadowOpacity = 0.27
        self.layer.shadowColor = UIColor.blackColor().CGColor
        
        configureForElevation(self.elevation)
    }
    
    func defaultConfigureForElevation(elevation:GMDElevation) {
        self.layer.shadowRadius = elevation.shadowRadius
        self.layer.shadowOffset = CGSizeMake(0, 0.75 * elevation.shadowRadius)
    }
    
    func defaultConfigureShadow() {
        let xR = min(self.frame.size.width, layer.cornerRadius)
        let yR = min(self.frame.size.height, layer.cornerRadius)
        
        self.layer.shadowPath = CGPathCreateWithRoundedRect(bounds, xR, yR, nil)
    }
}


public class GMDView: UIView, _GMDView {
    
    var elevation:GMDElevation = .Card {
        didSet {
            configureForElevation(elevation)
        }
    }
    
    public override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        configureAsGMD()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        defaultConfigureShadow()
    }
    
    func configureAsGMD() {
        defaultConfigureAsGMD()
    }
    
    func configureForElevation(elevation:GMDElevation) {
        defaultConfigureForElevation(elevation)
    }
}

class GMDThemeButton: ThemeButton, _GMDView {
    
    var elevation:GMDElevation = .Card {
        didSet {
            configureForElevation(elevation)
        }
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        configureAsGMD()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        defaultConfigureShadow()
        
        let raisedStates:[UIControlState] = [.Highlighted, .Selected]
        
        if state == .Disabled {
            self.elevation = .ButtonDisabled
        } else if raisedStates.contains(state) {
            self.elevation = .ButtonPressed
        } else {
            self.elevation = .Button
        }
    }
    
    func configureAsGMD() {
        defaultConfigureAsGMD()
    }
    
    func configureForElevation(elevation:GMDElevation) {
        defaultConfigureForElevation(elevation)
    }
}
