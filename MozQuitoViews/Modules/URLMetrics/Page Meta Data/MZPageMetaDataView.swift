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

public class GMDView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAsGMD()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        configureAsGMD()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.shadowPath = CGPathCreateWithRoundedRect(bounds, layer.cornerRadius, layer.cornerRadius, nil)
    }
    
    func configureAsGMD() {
        self.layer.cornerRadius = 2.0
        self.layer.shadowOpacity = 0.27
        self.layer.shadowRadius = 2.0
        self.layer.shadowOffset = CGSizeMake(0, 2.0)
        self.layer.shadowColor = UIColor.blackColor().CGColor
    }
}

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