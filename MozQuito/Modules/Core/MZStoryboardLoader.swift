//
//  MZStoryboardLoader.swift
//  MozQuito
//
//  Created by Josh Campion on 22/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import TheDistanceCore

enum MZStoryboadID:String {
    case Test
    case URLDetails
}

enum MZViewControllerID:String {
    case TestVC
    
    case URLDetailsVC
    case URLMetricsVC
    case URLLinksVC
}

class MZStoryboardLoader: StoryboardLoader {
    
    static func storyboardIdentifierForViewControllerIdentifier(viewControllerID: MZViewControllerID) -> MZStoryboadID {
        switch viewControllerID {
        case .TestVC:
            return .Test
        case .URLDetailsVC, .URLMetricsVC, .URLLinksVC:
            return .URLDetails
        }
    }
}

