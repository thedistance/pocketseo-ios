//
//  MZButton.swift
//  MozQuito
//
//  Created by Josh Campion on 24/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import TheDistanceCore

class MZButton: ThemeButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        styleTheme()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        styleTheme()
    }
    
    func styleTheme() {
        self.tintColourStyle = .Accent
        self.textStyle = .Body2
        self.contentEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
    }
    
}
