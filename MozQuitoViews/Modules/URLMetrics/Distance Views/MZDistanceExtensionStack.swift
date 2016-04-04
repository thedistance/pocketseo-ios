//
//  MZDistanceExtensionStack.swift
//  MozQuito
//
//  Created by Josh Campion on 29/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import TheDistanceCore
import StackView
import JCLocalization

protocol MZDistanceExtensionStackDelegate {
    
    func distanceStackRequestsOpenInApp(stack:MZDistanceStack, sender:UIButton)
}

class MZDistanceExtensionStack: MZDistanceStack {
    
    let openInAppButton = MZButton()
    
    private(set) var openInAppTarget:ObjectTarget<UIButton>?
    
    var delegate:MZDistanceExtensionStackDelegate?
    
    init() {
        
        super.init(buttons: [openInAppButton])
        
        openInAppButton.setTitle(LocalizedString(.URLExtensionOpenInAppButtonTitle), forState: .Normal)
        openInAppTarget = ObjectTarget<UIButton>(control: openInAppButton,
            forControlEvents: .TouchUpInside,
            completion: { (sender) -> () in
                self.delegate?.distanceStackRequestsOpenInApp(self, sender: sender)
        })
    }
}