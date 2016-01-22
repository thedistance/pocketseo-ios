//
//  AnalyticEntities.swift
//  MozQuito
//
//  Created by Josh Campion on 22/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import ViperKit

// MARK: - Enum Extensions

// Extend the general analytic event to use the enums specific to this app.
extension AnalyticEvent {
    
    /// Convenience initialiser to create a new event from enums for String safety
    init(category:AnalyticCategory, action:AnalyticAction, label:String?, userInfo:[String:Any]? = nil) {
        self.init(category: category.rawValue, action: action.rawValue, label: label, userInfo: userInfo)
    }
    
    /// Convenience initialiser to create a screen view event. Static keys are used to determine category and action so these events can be easily filtered by an AnalyticsInteractor.
    init(screenName:String) {
        self.init(category: .Screens, action: .Viewed, label: screenName)
    }
    
    /// Convenience initialiser to create a screen view event. Static keys are used to determine category and action so these events can be easily filtered by an AnalyticsInteractor.
    init(screenName:AnalyticScreen) {
        self.init(category: .Screens, action: .Viewed, label: screenName.rawValue)
    }
    
    /// Convenience comparison using Analytic enums.
    func isCategory(category:AnalyticCategory, andAction action:AnalyticAction) -> Bool {
        return self.category == category.rawValue && self.action == action.rawValue
    }
}

protocol AnalyticScreenView {
    
    var screenName:AnalyticScreen { get set }
    
    func registerScreenView()
}

extension AnalyticScreenView where Self:UIViewController {
    
    func registerScreenView() {
        AppDependencies.sharedDependencies().analyticsInteractor?.sendAnalytic(AnalyticEvent(screenName: screenName))
    }
}

// MARK: - Enums

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
