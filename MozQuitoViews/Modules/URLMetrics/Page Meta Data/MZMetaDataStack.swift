//
//  MZMetaDataStack.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView
import JCLocalization

class MZMetaDataStack: CreatedStack {
    
    let noContentString =  LocalizedString(.URLPageMetaDataNoContent)
    
    var value:String? {
        didSet {
            
            if let v = value where !v.isEmpty {
                valueLabel.text = v
            } else {
                valueLabel.text = noContentString
            }
        }
    }
    
    var characterCount:Int? {
        didSet {
            if let cc = characterCount {
                characterCountLabel.text = "\(cc)"
            } else {
                characterCountLabel.text = nil
            }
            
            characterCountLabel.sizeToFit()
            characterCountLabel.preferredMaxLayoutWidth = characterCountLabel.frame.size.width
        }
    }
    
    let titleLabel = ThemeLabel()
    let valueLabel = ThemeLabel()
    let characterCountLabel = ThemeLabel()
    
    let headingStack:StackView
    
    init(titleKey:LocalizationKey) {
        
        titleLabel.text = LocalizedString(titleKey).uppercaseString
        
        // fonts
        titleLabel.textStyle = .Caption
        titleLabel.textColourStyle = .SecondaryText
        
        characterCountLabel.textStyle = .Caption
        characterCountLabel.textColourStyle = .SecondaryText
        
        valueLabel.textStyle = .Body1
        valueLabel.textColourStyle = .Text
        
        // lines
        titleLabel.numberOfLines = 0
        valueLabel.numberOfLines = 0
        
        // compression / resistance
        titleLabel.setContentHuggingPriority(249, forAxis: .Horizontal)
        
        characterCountLabel.numberOfLines = 1
        characterCountLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        characterCountLabel.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        // characterCountLabel.addConstraints(NSLayoutConstraint.constraintsToSize(characterCountLabel, toWidth: 25, andHeight: nil))
        valueLabel.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        
        headingStack = CreateStackView([titleLabel, characterCountLabel])
        headingStack.axis = .Horizontal
        headingStack.stackDistribution = .EqualSpacing
        //headingStack.spacing = 8.0
        
        super.init(arrangedSubviews: [headingStack.view, valueLabel])
        stack.axis = .Vertical
        //stack.spacing = 8.0
    }
}