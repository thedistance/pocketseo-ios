//
//  NoInputView.swift
//  MozQuito
//
//  Created by Josh Campion on 07/04/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import Components
import JCLocalization

class NoInputView: MZErrorView {
    
    init() {
        
        super.init(image: UIImage(named: "BW Icon"),
                   message: LocalizedString(.URLMetricsEmptyText))
    }
    
    required init(image: UIImage?, message: String, spacing: CGFloat, imageView: UIImageView, label: UILabel, button: UIButton) {
        fatalError("init(image:message:spacing:imageView:label:button:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}