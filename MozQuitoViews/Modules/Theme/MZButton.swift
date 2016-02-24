//
//  MZButton.swift
//  MozQuito
//
//  Created by Josh Campion on 24/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import TheDistanceCore

class MZButton: GMDThemeButton {
    
    override func configureAsGMD() {
        super.configureAsGMD()
        
        self.backgroundColourStyle = .Accent
        self.tintColourStyle = .LightText
        self.textStyle = .Button
        self.contentEdgeInsets = UIEdgeInsetsMakeEqual(12.0)
    }
    
}
