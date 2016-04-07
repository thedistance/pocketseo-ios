//
//  MZDistanceApplicationStack.swift
//  MozQuito
//
//  Created by Josh Campion on 29/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import TheDistanceCore
import StackView
import JCLocalization

protocol MZDistanceApplicationStackDelegate {
    
    func distanceStackRequestsSendFeedback(stack:MZDistanceStack, sender:UIButton)
    func distanceStackRequestsGetInTouch(stack:MZDistanceStack, sender:UIButton)
    func distanceStackRequestsWebsite(stack:MZDistanceStack, sender:UIButton)
    
}

class MZDistanceApplicationStack: MZDistanceStack {
    
    let getInTouchButton = MZButton(type: .System)
    let sendFeedbackButton = MZButton(type: .System)
    let visitWebsite = MZButton(type: .System)
    
    private(set) var getInTouchTarget:ObjectTarget<UIButton>?
    private(set) var feedbackTarget:ObjectTarget<UIButton>?
    private(set) var websiteTarget:ObjectTarget<UIButton>?
    
    var delegate:MZDistanceApplicationStackDelegate?
    
    init() {
        
        super.init(buttons: [sendFeedbackButton, getInTouchButton, visitWebsite])
        
        // configure the buttons
        sendFeedbackButton.setTitle(LocalizedString(.TheDistancePanelButtonSendFeedback).uppercaseString, forState: .Normal)
        getInTouchButton.setTitle(LocalizedString(.TheDistancePanelButtonGetInTouch).uppercaseString, forState: .Normal)
        visitWebsite.setTitle(LocalizedString(.TheDistancePanelButtonVisitWebsite).uppercaseString, forState: .Normal)
        
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
