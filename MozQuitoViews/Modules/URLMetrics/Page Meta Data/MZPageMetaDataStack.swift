//
//  MZPageMetaDataStack.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView
import MozQuitoEntities

public class MZPageMetaDataStack: CreatedStack {
    
    static let dateFormatter:NSDateFormatter = {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        
        return formatter
    }()
    
    let expandButton = UIButton(type: .System)
    
    let titleStack = MZMetaDataStack(title: "PAGE TITLE")
    let canonicalStack = MZMetaDataStack(title: "CANONICAL URL")
    let descriptionStack = MZMetaDataStack(title: "META DESCRIPTION")
    let h1Stack = MZMetaDataStack(title: "H1")
    let h2Stack = MZMetaDataStack(title: "H2")
    
    private(set) var expandingTitleStack:StackView
    
    private(set) var detailsStack:StackView
    private(set) var footerStack:StackView
    
    let canonicalURLLabel = UILabel()
    let refreshDateLabel = UILabel()
    
    private(set) var expanded:Bool = false
    
    public var pageMetaData:MZPageMetaData? {
        didSet {
            
            let h1Text = pageMetaData?.htmlMetaData.h1Tags.joinWithSeparator("\u{2022}")
            let h2Text = pageMetaData?.htmlMetaData.h2Tags.joinWithSeparator("\u{2022}")
            
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
        detailsStack = CreateStackView([expandingTitleStack.view, canonicalStack.stackView, descriptionStack.stackView, h1Stack.stackView, h2Stack.stackView])
        footerStack = CreateStackView([canonicalURLLabel, refreshDateLabel])
        
        super.init(arrangedSubviews: [detailsStack.view, footerStack.view])
        
        configureStack()
    }
    
    func configureStack() {
        
        // configure the stacks
        expandingTitleStack.axis = .Horizontal
        expandingTitleStack.stackAlignment = .Fill
        expandingTitleStack.stackDistribution = .Fill
        expandingTitleStack.spacing = 8.0
        
        footerStack.axis = .Horizontal
        footerStack.spacing = 8.0
        
        detailsStack.axis = .Vertical
        detailsStack.spacing = 16.0
        
        // configure the labels
        canonicalURLLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        refreshDateLabel.font = canonicalURLLabel.font
        
        canonicalURLLabel.numberOfLines = 0
        
        canonicalURLLabel.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        refreshDateLabel.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        refreshDateLabel.setContentHuggingPriority(255, forAxis: .Horizontal)
        
        // configure button
        expandButton.setImage(UIImage(named: "ic_expand_more"), forState: .Normal)
        expandButton.contentHorizontalAlignment = .Left
        expandButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        
        self.stack.axis = .Vertical
        self.stack.stackAlignment = .Fill
        self.stack.stackDistribution = .Fill
        self.stack.spacing = 8.0
    }
    
    
    func toggleExpanded() {
        
        self.expanded = !expanded
        
        self.configureForExpanded(self.expanded)
        self.stackView.layoutIfNeeded()
    }
    
    func configureForExpanded(expanded:Bool) {
        
        let pi = CGFloat(M_PI)
        expandButton.transform = expanded ? CGAffineTransformMakeRotation(pi) : CGAffineTransformMakeRotation(2.0 * pi)
        
        
        expandingTitleStack.removeArrangedSubview(expandButton)
        expandingTitleStack.axis = expanded ? .Vertical : .Horizontal
        if expanded {
            expandingTitleStack.insertArrangedSubview(expandButton, atIndex: 0)
        } else {
            expandingTitleStack.addArrangedSubview(expandButton)
        }
        
        titleStack.headingStack.view.hidden = !expanded
        canonicalStack.stackView.hidden = !expanded
        descriptionStack.stackView.hidden = !expanded
        h1Stack.stackView.hidden = !expanded
        h2Stack.stackView.hidden = !expanded
    }
}
