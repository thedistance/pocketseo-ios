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

public class MZPageMetaDataView: MZPanel {
    
    public let metaStack = MZPageMetaDataStack()
    
    override public var stack:CreatedStack? {
        get {
            return metaStack
        }
        set { }
    }
}