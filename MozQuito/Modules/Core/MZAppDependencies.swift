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
    
    private var _authenticationToken:MZAuthenicationToken?
    
    var currentAuthenticationToken:MZAuthenicationToken {
        
        let expiryBuffer:NSTimeInterval = -10
        
        if let token = _authenticationToken where NSDate().timeIntervalSinceDate(token.expiryDate) < expiryBuffer {
            return token
        } else {
            let token = MZAuthenicationToken()
            _authenticationToken = token
            return token
        }
    }
    
    override required init() {
        super.init()
        
        guard !isTesting else { return }
        
        setDefaultPreferences()
        preferencesInteractor = self
        analyticsInteractor = GoogleAnalyticsInteractor()
        crashReportingInteractor = FabricCrashReportingInteractor()
        
        analyticsInteractor?.setupAnalytics()
        crashReportingInteractor?.setupCrashReporting()
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow) {
        
        guard !isTesting else {
            window.rootViewController = UIViewController()
            return
        }
        
        window.rootViewController = MZStoryboardLoader.instantiateViewControllerForIdentifier(.TestVC)
        
    }
    
}