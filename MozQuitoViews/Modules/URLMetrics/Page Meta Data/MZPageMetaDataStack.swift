//
//  MZPageMetaDataStack.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView
import PocketSEOEntities

public class MZPageMetaDataStack: CreatedStack {
    
    static let dateFormatter:NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .MediumStyle
        
        return formatter
    }()
    
    let expandButton = ThemeButton(type: .System)
    
    let titleStack = MZMetaDataStack(titleKey: .URLPageMetaDataPageTitle)
    let canonicalStack = MZMetaDataStack(titleKey: .URLPageMetaDataCanonicalURL)
    let descriptionStack = MZMetaDataStack(titleKey: .URLPageMetaDataMetaDescription)
    let h1Stack = MZMetaDataStack(titleKey: .URLPageMetaDataH1Tags)
    let h2Stack = MZMetaDataStack(titleKey: .URLPageMetaDataH2Tags)
    private(set) var usingSSLStack:StackView
    
    private(set) var expandingTitleStack:StackView
    
    private(set) var detailsStack:StackView
    private(set) var footerStack:StackView
    
    let usingSSLTitleLabel = ThemeLabel()
    let usingSSLSwitch = ThemeSwitch()
    let canonicalURLLabel = ThemeLabel()
    let refreshDateLabel = ThemeLabel()
    
    private(set) var expanded:Bool = false
    
    public var pageMetaData:MZPageMetaData? {
        didSet {
            
            let h1Text = pageMetaData?.htmlMetaData.h1Tags.joinWithSeparator(" \u{2022} ")
            let h2Text = pageMetaData?.htmlMetaData.h2Tags.joinWithSeparator(" \u{2022} ")
            
            let stackValues:[(stack:MZMetaDataStack, value:String?, charactercCount:Int?)] = [
                (titleStack, pageMetaData?.htmlMetaData.title, pageMetaData?.htmlMetaData.titleCharacterCount),
                (canonicalStack, pageMetaData?.htmlMetaData.canonicalURL?.absoluteString, pageMetaData?.htmlMetaData.canonicalURLCharacterCount),
                (descriptionStack, pageMetaData?.htmlMetaData.description, pageMetaData?.htmlMetaData.descriptionCharacterCount),
                (h1Stack, h1Text, pageMetaData?.htmlMetaData.h1TagsCharacterCount),
                (h2Stack, h2Text, pageMetaData?.htmlMetaData.h2TagsCharacterCount),
            ]
            
            for (stack, value, count) in stackValues {
                stack.value = value
                stack.characterCount = count
            }
            
            if let date = pageMetaData?.requestDate {
                refreshDateLabel.text = self.dynamicType.dateFormatter.stringFromDate(date)
            } else {
                refreshDateLabel.text = nil
            }
            
            if let str = pageMetaData?.htmlMetaData.canonicalURL?.absoluteString {
                canonicalURLLabel.text = str
            } else {
                canonicalURLLabel.text = nil
            }
            
            usingSSLSwitch.on = pageMetaData?.usingSSL ?? false
        }
    }
    
    init() {
        
        // init as collapsed
        titleStack.headingStack.view.hidden = true
        canonicalStack.stackView.hidden = true
        descriptionStack.stackView.hidden = true
        h1Stack.stackView.hidden = true
        h2Stack.stackView.hidden = true
        
        expandingTitleStack = CreateStackView([titleStack.stackView, expandButton])
        usingSSLStack = CreateStackView([usingSSLTitleLabel, usingSSLSwitch])
        detailsStack = CreateStackView([expandingTitleStack.view, canonicalStack.stackView, descriptionStack.stackView, h1Stack.stackView, h2Stack.stackView, usingSSLStack.view])
        footerStack = CreateStackView([canonicalURLLabel, refreshDateLabel])
        
        usingSSLStack.view.hidden = true
        
        super.init(arrangedSubviews: [detailsStack.view, footerStack.view])
        
        configureStack()
    }
    
    func configureStack() {
        
        // configure the stacks
        expandingTitleStack.axis = .Horizontal
        expandingTitleStack.stackAlignment = .Fill
        expandingTitleStack.stackDistribution = .Fill
        expandingTitleStack.spacing = 8.0
        
        titleStack.valueLabel.textStyle = .Title
        
        footerStack.axis = .Horizontal
        footerStack.spacing = 8.0
        footerStack.stackDistribution = .EqualSpacing
        
        detailsStack.axis = .Vertical
        detailsStack.spacing = 16.0
        
        // configure the labels
        canonicalURLLabel.textStyle = .Caption
        canonicalURLLabel.textColourStyle = .SecondaryText
        
        refreshDateLabel.textStyle = .Caption
        refreshDateLabel.textColourStyle = .SecondaryText
        
        usingSSLTitleLabel.textStyle = .Body1
        usingSSLTitleLabel.textColourStyle = .Text
        
        canonicalURLLabel.numberOfLines = 0
        usingSSLTitleLabel.numberOfLines = 0
        
        usingSSLTitleLabel.text = MZLocalizedString(.URLPageMetaDataUsingSSL)
        usingSSLStack.stackDistribution = .EqualSpacing
        
        canonicalURLLabel.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        refreshDateLabel.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        refreshDateLabel.setContentHuggingPriority(255, forAxis: .Horizontal)
        
        // configure button
        expandButton.setImage(UIImage(named: "ic_expand_more"), forState: .Normal)
        expandButton.tintColourStyle = .Accent
        expandButton.contentHorizontalAlignment = .Left
        expandButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        
        usingSSLSwitch.userInteractionEnabled = false
        usingSSLSwitch.onTintColourStyle = .Accent
        
        self.stack.axis = .Vertical
        self.stack.stackAlignment = .Fill
        self.stack.stackDistribution = .Fill
        self.stack.spacing = 16.0
    }
    
    
    public func toggleExpanded() {
        
        self.configureAsExpanded(!self.expanded)
        self.stackView.layoutIfNeeded()
    }
    
    public func configureAsExpanded(expanded:Bool) {
     
        self.expanded = expanded
        
        let pi = CGFloat(M_PI)
        expandButton.transform = expanded ? CGAffineTransformMakeRotation(pi) : CGAffineTransformMakeRotation(2.0 * pi)
        
        titleStack.headingStack.view.hidden = !expanded
        canonicalStack.stackView.hidden = !expanded
        descriptionStack.stackView.hidden = !expanded
        h1Stack.stackView.hidden = !expanded
        h2Stack.stackView.hidden = !expanded
        
        usingSSLStack.view.hidden = !expanded
    }
}
