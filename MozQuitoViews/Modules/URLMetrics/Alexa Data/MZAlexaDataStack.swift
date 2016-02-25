//
//  MZAlexaDataView.swift
//  MozQuito
//
//  Created by Josh Campion on 22/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import TheDistanceCore
import StackView
import JCLocalization
/// The string used to represent no value from a sever response. This differs from 0 which could have different meaning.
let NoValueString = "-"

public class MZAlexaDataStack: MZExpandingStack {
    
    var alexaData:MZAlexaData? {
        didSet {
            
            let numberStrings = [alexaData?.popularityText,
                alexaData?.reachRank,
                alexaData?.rankDelta]
                .map({ $0 == nil ? nil : LargeNumberFormatter.numberFromString($0!) })
                .map({ $0 == nil ? nil : LargeNumberFormatter.stringFromNumber($0!) })
                .map({ $0 ?? NoValueString })
            
            popularityStack.labels[0].text = numberStrings[0]
            reachRankStack.labels[0].text = numberStrings[1]
            rankDeltaStack.labels[0].text = numberStrings[2]
        }
    }
    
    let popularityStack = GenericStringsStack<ThemeLabel>(strings:[NoValueString, LocalizedString(.URLAlexaPopularity)])
    let reachRankStack = GenericStringsStack<ThemeLabel>(strings:[NoValueString, LocalizedString(.URLAlexaReachRank)])
    let rankDeltaStack = GenericStringsStack<ThemeLabel>(strings:[NoValueString, LocalizedString(.URLAlexaRankDelta)])
    
    init() {
        
        let titleImage = UIImage(named: "Alexa Logo",
            inBundle: NSBundle(forClass: MZAlexaDataStack.self),
            compatibleWithTraitCollection: nil)
        
        let titleImageView = UIImageView(image: titleImage)
        titleImageView.contentMode = .ScaleAspectFit
        titleImageView.setContentHuggingPriority(500, forAxis: .Vertical)
        
        let stacks = [popularityStack, reachRankStack, rankDeltaStack]

        for s in stacks {
            s.stack.axis = .Horizontal
            s.stack.spacing = 4.0
            s.stack.stackAlignment = .FirstBaseline
            
            s.labels[0].textStyle = .Display1
            s.labels[0].textColourStyle = .Text
            s.labels[0].setContentHuggingPriority(255, forAxis: .Horizontal)
            
            s.labels[1].textStyle = .Body1
            s.labels[1].textColourStyle = .SecondaryText
        }
        
        super.init(titleView: titleImageView, arrangedSubviews:stacks.map({ $0.stackView }))
        
        expandButton.alpha = 0.0
        
        stack.axis = .Vertical
        stack.spacing = 16.0
    }
}


