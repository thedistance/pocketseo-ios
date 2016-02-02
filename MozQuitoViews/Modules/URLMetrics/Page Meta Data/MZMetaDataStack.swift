//
//  MZMetaDataStack.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView

class MZMetaDataStack: CreatedStack {
    
    var value:String? {
        didSet {
            valueLabel.text = value
        }
    }
    
    var characterCount:Int? {
        didSet {
            if let cc = characterCount {
                characterCountLabel.text = "\(cc)"
            } else {
                characterCountLabel.text = nil
            }
        }
    }
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let characterCountLabel = UILabel()
    
    let headingStack:StackView
    
    init(title:String) {
        
        titleLabel.text = title
        
        // fonts
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        characterCountLabel.font = titleLabel.font
        valueLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
        // lines
        titleLabel.numberOfLines = 0
        valueLabel.numberOfLines = 0
        
        // compression / resistance
        titleLabel.setContentHuggingPriority(249, forAxis: .Horizontal)
        characterCountLabel.setContentHuggingPriority(500, forAxis: .Horizontal)
        characterCountLabel.setContentCompressionResistancePriority(755, forAxis: .Horizontal)
        
        valueLabel.setContentCompressionResistancePriority(755, forAxis: .Vertical)
        
        headingStack = CreateStackView([titleLabel, characterCountLabel])
        headingStack.axis = .Horizontal
        //headingStack.spacing = 8.0
        
        super.init(arrangedSubviews: [headingStack.view, valueLabel])
        stack.axis = .Vertical
        //stack.spacing = 8.0
    }
}