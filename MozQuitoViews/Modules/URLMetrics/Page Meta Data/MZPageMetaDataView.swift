//
//  MZPageMetaDataView.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import StackView
import TheDistanceCore

public class MZPageMetaDataView: GMDView {
    
    public let metaStack = MZPageMetaDataStack()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureHierarchy()
    }
    
    func configureHierarchy() {
        
        metaStack.stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(metaStack.stackView)
        addConstraints(NSLayoutConstraint.constraintsToAlign(view: metaStack.stackView, to: self, withInsets: UIEdgeInsetsZero, relativeToMargin: (true, true, true, true)))
        
        self.backgroundColor = UIColor.whiteColor()
    }
}