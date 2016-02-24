//
//  MZAnalytics.swift
//  MozQuito
//
//  Created by Josh Campion on 24/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

// APP SPECIFIC

// MARK: - App Keys

let GoogleAnalyticsTrackingIDLive = "UA-21295891-5"
let GoogleAnalyticsTrackingIDStaging = "UA-58260965-6"

// MARK: - Analytic Enums

// MARK: Screen Names

enum AnalyticScreen:String {
    case Test
}

// MARK: Analytic Categories

enum AnalyticCategory:String {
    case Screens
    case Test
}

// MARK: Analytic Actions

enum AnalyticAction:String {
    
    // Category: Screens
    case Viewed
    case Test
}