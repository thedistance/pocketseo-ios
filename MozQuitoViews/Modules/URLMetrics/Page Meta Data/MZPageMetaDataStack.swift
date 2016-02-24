//
//  MZPageMetaDataStack.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import TheDistanceCore
import StackView
import JCLocalization

public class MZPageMetaDataStack: MZExpandingStack {
    
    static let dateFormatter:NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .MediumStyle
        
        return formatter
    }()
    
    let pageTitleStack = MZMetaDataStack(titleKey: .URLPageMetaDataPageTitle)
    let canonicalStack = MZMetaDataStack(titleKey: .URLPageMetaDataCanonicalURL)
    let descriptionStack = MZMetaDataStack(titleKey: .URLPageMetaDataMetaDescription)
    let h1Stack = MZMetaDataStack(titleKey: .URLPageMetaDataH1Tags)
    let h2Stack = MZMetaDataStack(titleKey: .URLPageMetaDataH2Tags)
    private(set) var usingSSLStack:StackView
    
    private(set) var detailsStack:StackView
    private(set) var footerStack:StackView
    
    let usingSSLTitleLabel = ThemeLabel()
    let usingSSLSwitch = ThemeSwitch()
    let responseURLLabel = ThemeLabel()
    let refreshDateLabel = ThemeLabel()
    
    public var pageMetaData:MZPageMetaData? {
        didSet {
            
            let h1Text = pageMetaData?.htmlMetaData.h1Tags.joinWithSeparator(" \u{2022} ")
            let h2Text = pageMetaData?.htmlMetaData.h2Tags.joinWithSeparator(" \u{2022} ")
            
            let stackValues:[(stack:MZMetaDataStack, value:String?, charactercCount:Int?)] = [
                (pageTitleStack, pageMetaData?.htmlMetaData.title, pageMetaData?.htmlMetaData.titleCharacterCount),
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
            
            if let str = pageMetaData?.responseURL.absoluteString {
                responseURLLabel.text = str
            } else {
                responseURLLabel.text = nil
            }
            
            usingSSLSwitch.on = pageMetaData?.usingSSL ?? false
        }
    }
    
    init() {
        
        // init as collapsed
        pageTitleStack.headingStack.view.hidden = true
        canonicalStack.stackView.hidden = true
        descriptionStack.stackView.hidden = true
        h1Stack.stackView.hidden = true
        h2Stack.stackView.hidden = true
        
        usingSSLStack = CreateStackView([usingSSLTitleLabel, usingSSLSwitch])
        
        detailsStack = CreateStackView([pageTitleStack.stackView,
            canonicalStack.stackView,
            descriptionStack.stackView,
            h1Stack.stackView,
            h2Stack.stackView,
            usingSSLStack.view])
        footerStack = CreateStackView([responseURLLabel, refreshDateLabel])
        
        usingSSLStack.view.hidden = true
        
        let titleLabel = ThemeLabel()
        titleLabel.textStyle = .Title
        titleLabel.textColourStyle = .Text
        titleLabel.text = LocalizedString(.URLPageMetaDataHeadline)
        
        super.init(titleView: titleLabel, arrangedSubviews: [detailsStack.view, footerStack.view])
    }
    
    override func configureStack() {
        
        super.configureStack()
        
        // configure the stacks
        footerStack.axis = .Horizontal
        footerStack.spacing = 8.0
        footerStack.stackDistribution = .EqualSpacing
        
        detailsStack.axis = .Vertical
        detailsStack.spacing = 16.0
        
        // configure the labels
        responseURLLabel.textStyle = .Caption
        responseURLLabel.textColourStyle = .SecondaryText
        
        refreshDateLabel.textStyle = .Caption
        refreshDateLabel.textColourStyle = .SecondaryText
        
        usingSSLTitleLabel.textStyle = .Body1
        usingSSLTitleLabel.textColourStyle = .Text
        
        responseURLLabel.numberOfLines = 0
        usingSSLTitleLabel.numberOfLines = 0
        
        usingSSLTitleLabel.text = LocalizedString(.URLPageMetaDataUsingSSL)
        usingSSLStack.stackDistribution = .EqualSpacing
        
        responseURLLabel.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        refreshDateLabel.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        refreshDateLabel.setContentHuggingPriority(255, forAxis: .Horizontal)
        
        usingSSLSwitch.userInteractionEnabled = false
        usingSSLSwitch.onTintColourStyle = .Accent
        
    }
    
    public override func configureAsExpanded(expanded: Bool) {
        
        super.configureAsExpanded(expanded)
        
        pageTitleStack.headingStack.view.hidden = !expanded
        canonicalStack.stackView.hidden = !expanded
        descriptionStack.stackView.hidden = !expanded
        h1Stack.stackView.hidden = !expanded
        h2Stack.stackView.hidden = !expanded
        
        usingSSLStack.view.hidden = !expanded
    }
    
}
