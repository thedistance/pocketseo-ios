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
    
    let mailDelegate = MailDelegate()
    
    init() {
        
        headlineLabel.textStyle = .Title
        headlineLabel.textColourStyle = .Text
        headlineLabel.text = LocalizedString(.TheDistancePanelHeadline)
        headlineLabel.setContentHuggingPriority(755, forAxis: .Horizontal)
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
        
    }
    
    func sendFeedbackTapped(sender:UIButton) {
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = mailDelegate
        
        mailVC.setToRecipients([LocalizedString(.TheDistanceContactEmail)])
        mailVC.setSubject(LocalizedString(.TheDistancePanelSendFeedbackSubject))
        
        let appName = (NSBundle.mainBundle().infoDictionary?["CFBundleIdentifier"] as? String) ?? "PocketSEO"
        let appVersion = (NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String) ?? "-"
        let emailBody = String(format: LocalizedString(.TheDistancePanelEmailBody), appName, appVersion)
        
        mailVC.setMessageBody(emailBody, isHTML: false)
        
        UIViewController.topPresentedViewController()?.navigationTopViewController()?.presentViewController(mailVC, fromSourceItem: .View(sendFeedbackButton))
    }
    
    func visitWebsiteTapped(sender:UIButton) {
        
        guard let url = NSURL(string: LocalizedString(.TheDistancePanelVisitWebsiteURL)) else { return }
        
        UIViewController.topPresentedViewController()?.navigationTopViewController()?.openURL(url, fromSourceItem: .View(visitWebsite))
    }
    
    class MailDelegate: NSObject, MFMailComposeViewControllerDelegate {
        
        func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
}

