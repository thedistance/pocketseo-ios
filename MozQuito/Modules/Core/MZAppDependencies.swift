//
//  MZAppDependencies.swift
//  MozQuito
//
//  Created by Josh Campion on 22/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ViperKit

class MZAppDependencies : AppDependencies, _AppDependencies, PreferencesInteractor {
    
    override required init() {
        super.init()
        
        setDefaultPreferences()
        preferencesInteractor = self
        analyticsInteractor = GoogleAnalyticsInteractor()
        crashReportingInteractor = FabricCrashReportingInteractor()
        
        analyticsInteractor?.setupAnalytics()
        crashReportingInteractor?.setupCrashReporting()
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow) {
        
        window.rootViewController = MZStoryboardLoader.instantiateViewControllerForIdentifier(.TestVC)
        
    }
    
}