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


protocol MZDistanceStackDelegate {
    
    func distanceStackRequestsSendFeedback(stack:MZDistanceStack, sender:UIButton)
    func distanceStackRequestsGetInTouch(stack:MZDistanceStack, sender:UIButton)
    func distanceStackRequestsWebsite(stack:MZDistanceStack, sender:UIButton)
    
}

class MZDistanceStack: CreatedStack {
    
    let headlineLabel = ThemeLabel()
    let logoImageView = ThemeImageView()
    let taglineLabel = ThemeLabel()
    
    let getInTouchButton = MZButton()
    let sendFeedbackButton = MZButton()
    let visitWebsite = MZButton()
    
    private(set) var getInTouchTarget:ObjectTarget<UIButton>?
    private(set) var feedbackTarget:ObjectTarget<UIButton>?
    private(set) var websiteTarget:ObjectTarget<UIButton>?
    
    var headingStack:StackView
    var taglineStack:StackView
    var buttonStack:StackView
        
    var delegate:MZDistanceStackDelegate?
    
    init() {
        
        headlineLabel.textStyle = .Title
        headlineLabel.textColourStyle = .Text
        headlineLabel.text = LocalizedString(.TheDistancePanelHeadline)
        // explicit layout width for iOS 8
        headlineLabel.preferredMaxLayoutWidth = 320.0
        headlineLabel.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        headlineLabel.numberOfLines = 0
        
        let logoImage = UIImage(named: "TheDistance Logo",
            inBundle: NSBundle(forClass: MZDistanceStack.self),
            compatibleWithTraitCollection: nil)
        logoImageView.image = logoImage
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
        headingStack.stackAlignment = .Fill
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
        
        getInTouchTarget = ObjectTarget(control: getInTouchButton, forControlEvents: .TouchUpInside, completion: getInTouchTapped)
        feedbackTarget = ObjectTarget(control: sendFeedbackButton, forControlEvents: .TouchUpInside, completion: sendFeedbackTapped)
        websiteTarget = ObjectTarget(control: visitWebsite, forControlEvents: .TouchUpInside, completion: visitWebsiteTapped)
        
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
    
    func getInTouchTapped(sender:UIButton) {
        delegate?.distanceStackRequestsGetInTouch(self, sender: sender)
    }
    
    func sendFeedbackTapped(sender:UIButton) {
        delegate?.distanceStackRequestsSendFeedback(self, sender: sender)
    }
    
    func visitWebsiteTapped(sender:UIButton) {
        delegate?.distanceStackRequestsWebsite(self, sender: sender)
    }
}

