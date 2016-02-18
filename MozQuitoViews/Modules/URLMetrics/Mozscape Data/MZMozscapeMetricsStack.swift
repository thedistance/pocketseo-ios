//
//  MZMozscapeMetricsStack.swift
//  MozQuito
//
//  Created by Josh Campion on 18/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView

public class MZMozscapeIndexedStack:CreatedStack {
    
    let dateFormatted: NSDateFormatter = {
       
        let formatter = NSDateFormatter()
        formatter.timeStyle = .NoStyle
        formatter.dateStyle = .ShortStyle
        
        return formatter
    }()
    
    var dates:MZMozscapeIndexedDates? {
        didSet {
            
        }
    }
    
    let lastDateLabel = ThemeLabel()
    let lastDateTitleLabel = ThemeLabel()
    
    let nextDateLabel = ThemeLabel()
    let nextDateTitleLabel = ThemeLabel()
    
    init() {
        
        let lastStack = GenericStringsStack<ThemeLabel>(strings: [MZLocalizedString(.URLMozscapeLastIndexedTitle), "-"])
        let nextStack = GenericStringsStack<ThemeLabel>(strings: [MZLocalizedString(.URLMozscapeNextIndexedTitle), "-"])
        
        for l in [lastStack.labels[0], nextStack.labels[0]] {
            l.textStyle = .Caption
            l.textColourStyle = .SecondaryText
            l.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        }
        
        for l in [lastStack.labels[1], nextStack.labels[1]] {
            l.textStyle = .Body1
            l.textColourStyle = .Text
            l.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        }
        
        for l in nextStack.labels {
            l.textAlignment = .Right
        }
        
        super.init(arrangedSubviews: [lastStack.stackView, nextStack.stackView])
        
        stack.stackDistribution = .FillEqually
        stack.axis = .Horizontal
        stack.spacing = 8.0
    }
    
}

public class MZMozscapeMetricsStack: MZExpandingStack {
    
    var data:MZMozscapeMetrics? {
        didSet {
            
        }
    }
    
    let authorityHeadingStack:StackView

    let linksHeadingStack:StackView
    
    let rootLinksStack = GenericStringsStack<ThemeLabel>(strings: ["-", MZLocalizedString(.URLMozscapeLinksRootDomain)])
    
    let totalLinksStack = GenericStringsStack<ThemeLabel>(strings: ["-", MZLocalizedString(.URLMozscapeLinksTotalLinks)])
    
    let indexedStack = MZMozscapeIndexedStack()
    
    init() {
        
        // create the title views
        let mozImage = UIImage(named: "Moz Logo",
            inBundle: NSBundle(forClass: MZMozscapeMetricsStack.self),
            compatibleWithTraitCollection: nil)
        
        let titleImageView = UIImageView(image: mozImage)
        titleImageView.contentMode = .ScaleAspectFit
        
        // create the authority section
        
        let authorityTitleLabel = ThemeLabel()
        authorityTitleLabel.textStyle = .SubHeadline
        authorityTitleLabel.textColourStyle = .Text
        authorityTitleLabel.text = MZLocalizedString(.URLMozscapeAuthorityTitle)
        
        let authorityInfoButton = ThemeButton(type: .InfoDark)
        authorityInfoButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        authorityInfoButton.tintColourStyle = .Accent
        
        authorityHeadingStack = CreateStackView([authorityTitleLabel, authorityInfoButton])
        authorityHeadingStack.spacing = 8.0
        
        // ...create the authority charts
        
        // separate the sections
        
        let separator1 = ThemeView()
        separator1.backgroundColourStyle = .SecondaryText
        
        // create the Links Section
        
        let linksTitleLabel = ThemeLabel()
        linksTitleLabel.textStyle = .SubHeadline
        linksTitleLabel.textColourStyle = .Text
        linksTitleLabel.text = MZLocalizedString(.URLMozscapeLinksTitle)
        
        let linksInfoButton = ThemeButton(type: .InfoDark)
        linksInfoButton.setContentHuggingPriority(255, forAxis: .Horizontal)
        linksInfoButton.tintColourStyle = .Accent
        
        linksHeadingStack = CreateStackView([linksTitleLabel, linksInfoButton])
        linksHeadingStack.spacing = 8.0
        
        // create the content labels
        
        for l in [rootLinksStack.labels[0], totalLinksStack.labels[0]] {
            l.textStyle = .Display1
            l.textColourStyle = .Text
            l.setContentHuggingPriority(255, forAxis: .Horizontal)
        }
        
        for l in [rootLinksStack.labels[1], totalLinksStack.labels[1]] {
            l.textStyle = .Body1
            l.textColourStyle = .SecondaryText
        }
        
        for var s in [rootLinksStack.stack, totalLinksStack.stack] {
            s.axis = .Horizontal
            s.stackAlignment = .FirstBaseline
            s.spacing = 8.0
        }
        
        // separate the sections
        
        let separator2 = ThemeView()
        separator2.backgroundColourStyle = .SecondaryText
        
        for s in [separator1, separator2] {
            s.addConstraints(NSLayoutConstraint.constraintsToSize(s, toWidth: nil, andHeight: 1.0))
        }
        
        super.init(titleView: titleImageView, arrangedSubviews: [authorityHeadingStack.view,
            separator1,
            linksHeadingStack.view,
            rootLinksStack.stackView,
            totalLinksStack.stackView,
            separator2,
            indexedStack.stackView])
        
        stack.axis = .Vertical
        stack.spacing = 8.0
    }
    
}