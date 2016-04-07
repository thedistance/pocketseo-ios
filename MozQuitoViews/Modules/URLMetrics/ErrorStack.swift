//
//  ErrorStack.swift
//  MozQuito
//
//  Created by Josh Campion on 22/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import Components

public class MZErrorView: ErrorView {
    
    init(image:UIImage?, message:String) {
        
        let l = ThemeLabel()
        l.textStyle = .Body1
        l.textColourStyle = .SecondaryText
        l.numberOfLines = 0
        l.textAlignment = .Center
        
        let i = ThemeImageView()
        i.tintColourStyle = .SecondaryText
        i.contentMode = .ScaleAspectFit
        
        super.init(image: image,
                   message: message,
                   spacing: 8.0,
                   imageView: i,
                   label: l)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init(image: UIImage?, message: String, spacing: CGFloat, imageView: UIImageView, label: UILabel, button: UIButton) {
        fatalError("init(image:message:spacing:imageView:label:button:) has not been implemented")
    }

}
