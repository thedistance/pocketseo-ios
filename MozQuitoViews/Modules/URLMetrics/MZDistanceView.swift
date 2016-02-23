//
//  MZDistanceView.swift
//  MozQuito
//
//  Created by Josh Campion on 23/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import TheDistanceCore
import StackView
import JCLocalization

class MZButton: GMDThemeButton {
    
    override func configureAsGMD() {
        super.configureAsGMD()
        
        self.backgroundColourStyle = .Accent
        self.tintColourStyle = .LightText
        self.textStyle = .Button
        self.contentEdgeInsets = UIEdgeInsetsMakeEqual(12.0)
    }
    
}

class MZDistanceStack: CreatedStack {
    
    let headlineLabel = ThemeLabel()
    let logoImageView = ThemeImageView()
    let taglineLabel = ThemeLabel()
    
    let getInTouchButton = MZButton()
    let sendFeedbackButton = MZButton()
    let visitWebsite = MZButton()
    
    private(set) var buttonStack:StackView
    
    init() {
        
        headlineLabel.textStyle = .Title
        headlineLabel.textColourStyle = .Text
        headlineLabel.text = LocalizedString(.TheDistancePanelHeadline)
        headlineLabel.numberOfLines = 0
        
        let logoImage = UIImage(named: "TheDistance Logo",
            inBundle: NSBundle(forClass: MZDistanceStack.self),
            compatibleWithTraitCollection: nil)
        logoImageView.image = logoImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 612, 0, 0))
        logoImageView.contentMode = .ScaleToFill
        
        
        taglineLabel.textStyle = .Body1
        taglineLabel.textColourStyle = .Text
        taglineLabel.text = LocalizedString(.TheDistancePanelTagline)
        taglineLabel.numberOfLines = 0
        
        sendFeedbackButton.setTitle(LocalizedString(.TheDistancePanelButtonSendFeedback).uppercaseString, forState: .Normal)
        getInTouchButton.setTitle(LocalizedString(.TheDistancePanelButtonGetInTouch).uppercaseString, forState: .Normal)
        visitWebsite.setTitle(LocalizedString(.TheDistancePanelButtonVisitWebsite).uppercaseString, forState: .Normal)
        
        buttonStack = CreateStackView([sendFeedbackButton, getInTouchButton, visitWebsite])
        buttonStack.axis = .Vertical
        buttonStack.spacing = 16.0
        
        super.init(arrangedSubviews: [headlineLabel, logoImageView, taglineLabel, buttonStack.view])
        stack.axis = .Vertical
        stack.spacing = 16.0
        
        for b in [getInTouchButton, visitWebsite] {
            stack.view.addConstraint(NSLayoutConstraint(item: b,
                attribute: .Width,
                relatedBy: .Equal,
                toItem: sendFeedbackButton,
                attribute: .Width,
                multiplier: 1.0,
                constant: 0.0))
        }
    }
}

class MZDistanceView: GMDView {
    
    private(set) var tdStack = MZDistanceStack()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureHierarchy()
    }
    
    func configureHierarchy() {
        
        tdStack.stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tdStack.stackView)
        addConstraints(NSLayoutConstraint.constraintsToAlign(view: tdStack.stackView, to: self, withInsets: UIEdgeInsetsMake(8, 0, 8, 0), relativeToMargin: (true, true, true, true)))
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let newAxis:UILayoutConstraintAxis = traitCollection.horizontalSizeClass == .Compact ? .Vertical : .Horizontal
        if tdStack.buttonStack.axis != newAxis {
            tdStack.buttonStack.axis = newAxis
        }
    }
}