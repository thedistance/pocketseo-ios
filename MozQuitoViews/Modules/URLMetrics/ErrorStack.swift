//
//  ErrorStack.swift
//  MozQuito
//
//  Created by Josh Campion on 22/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import StackView

public class ErrorStack: CreatedStack {
    
    var message:String {
        didSet {
            label.text = message
        }
    }
    
    let label = ThemeLabel()
    
    init(image:UIImage = UIImage(named: "Error")!, message:String) {
        
        let iv = ThemeImageView(image: image)
        iv.contentMode = .ScaleAspectFit
        iv.tintColourStyle = .SecondaryText
        
        self.message = message
        label.text = message
        label.textStyle = .Body1
        label.textColourStyle = .SecondaryText
        label.numberOfLines = 0
        label.textAlignment = .Center
        
        super.init(arrangedSubviews: [iv, label])
        
        stack.axis = .Vertical
        stack.spacing = 8.0
    }
    
}