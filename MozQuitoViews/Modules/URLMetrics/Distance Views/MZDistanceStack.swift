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

/**

 Super class for The Distance branding and contact.
 
 - seealso: `MZDistanceExtensionStack`, `MZDistanceApplicationStack`
*/
class MZDistanceStack: CreatedStack {
    
    let headlineLabel = ThemeLabel()
    let logoImageView = ThemeImageView()
    let taglineLabel = ThemeLabel()
    
    var headingStack:StackView
    var taglineStack:StackView
    
    var buttonStack:StackView
    
    init(buttons:[UIButton]) {
        
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

        buttonStack = CreateStackView(buttons)
        buttonStack.axis = .Horizontal
        buttonStack.spacing = 1.0
        buttonStack.stackAlignment = .Fill
        buttonStack.stackDistribution = .FillProportionally
        
        super.init(arrangedSubviews: [headingStack.view, buttonStack.view])
        stack.axis = .Vertical
        stack.spacing = 16.0
    }
}




