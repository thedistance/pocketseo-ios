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
import MessageUI

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
    
    private(set) var headingStack:StackView
    private(set) var taglineStack:StackView
    private(set) var buttonStack:StackView
    
    init() {
        
        headlineLabel.textStyle = .Title
        headlineLabel.textColourStyle = .Text
        headlineLabel.text = LocalizedString(.TheDistancePanelHeadline)
        headlineLabel.setContentHuggingPriority(755, forAxis: .Horizontal)
        headlineLabel.numberOfLines = 0
        
        let logoImage = UIImage(named: "TheDistance Logo",
            inBundle: NSBundle(forClass: MZDistanceStack.self),
            compatibleWithTraitCollection: nil)
        logoImageView.image = logoImage//?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 412, 0, 0))
        logoImageView.contentMode = .ScaleAspectFit
        
        
        taglineLabel.textStyle = .Body1
        taglineLabel.textColourStyle = .Text
        taglineLabel.text = LocalizedString(.TheDistancePanelTagline)
        taglineLabel.numberOfLines = 0
        taglineLabel.textAlignment = .Center
        taglineStack = CreateStackView([logoImageView, taglineLabel])
        taglineStack.axis = .Vertical
        taglineStack.spacing = 16.0
        
        headingStack = CreateStackView([headlineLabel, taglineStack.view])
        headingStack.axis = .Horizontal
        headingStack.stackAlignment = .Leading
        headingStack.stackDistribution = .EqualSpacing
        headingStack.spacing = 16.0
        
        sendFeedbackButton.setTitle(LocalizedString(.TheDistancePanelButtonSendFeedback).uppercaseString, forState: .Normal)
        getInTouchButton.setTitle(LocalizedString(.TheDistancePanelButtonGetInTouch).uppercaseString, forState: .Normal)
        visitWebsite.setTitle(LocalizedString(.TheDistancePanelButtonVisitWebsite).uppercaseString, forState: .Normal)
        
        buttonStack = CreateStackView([sendFeedbackButton, getInTouchButton, visitWebsite])
        buttonStack.axis = .Vertical
        buttonStack.spacing = 16.0
        
        
        
        super.init(arrangedSubviews: [headingStack.view, buttonStack.view])
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
    
    func getInTouchTapped(sender:AnyObject?) {
        
    }
    
    func sendFeedbackTapped(sender:AnyObject?) {
        
    }
    
    func visitWebsiteTapped(sender:AnyObject?) {
        
        guard let url = NSURL(string: LocalizedString(.TheDistancePanelVisitWebsiteURL)) else { return }
        
        UIViewController.topPresentedViewController()?.navigationTopViewController()?.openURL(url, fromSourceItem: .View(visitWebsite))
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