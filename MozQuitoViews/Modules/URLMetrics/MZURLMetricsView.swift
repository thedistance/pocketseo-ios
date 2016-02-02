//
//  MZURLMeticsStack.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import StackView
import TheDistanceCore
import PocketSEOEntities

public class MZURLMetricsStack:CreatedStack {
    
    public let pageMetaDataView = MZPageMetaDataView(frame: CGRectMake(0, 0, 320, 64))
    
    public init() {
        super.init(arrangedSubviews: [pageMetaDataView])
    }
    
}

@IBDesignable
public class MZURLMetricsView: UIView {
    
    public var pageMetaData:MZPageMetaData? {
        didSet {
            metricsStack.pageMetaDataView.metaStack.pageMetaData = pageMetaData
        }
    }
    
    public let metricsStack = MZURLMetricsStack()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configureHierarchy()
    }
    
    func configureHierarchy() {
        
        metricsStack.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(metricsStack.stackView)
        addConstraints(NSLayoutConstraint.constraintsToAlign(view: metricsStack.stackView, to: self, withInsets: UIEdgeInsetsMakeEqual(8.0)))
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        metricsStack.pageMetaDataView.metaStack.toggleExpanded()
        metricsStack.pageMetaDataView.metaStack.pageMetaData = MZPageMetaData.TheDistanceMetaData()
    }
}