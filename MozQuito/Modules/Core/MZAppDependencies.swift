//
//  MZAppDependencies.swift
//  MozQuito
//
//  Created by Josh Campion on 22/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import Components
import TheDistanceCore
import ThemeKitCore
//import PocketSEOViews

let isTesting:Bool = {
    return NSProcessInfo.processInfo().environment["TESTING"] != nil
}()

enum RequestKeys:String, RequestCacheKey {
    case MozscapeIndexedDates
    
    var keyString:String {
        return rawValue
    }
    
    static var allValues:[RequestKeys] = [.MozscapeIndexedDates]
}

class MZAppDependencies : AppDependencies, _AppDependencies, RequestCache {
    
    typealias RequestCacheKeyType = RequestKeys
    
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
        
        // pass the preferences as a reference for dependebct injection and to prevent cyclic loop
        analyticsReporter = GoogleAnalyticsInteractor(preferences: self)
        crashReporter = FabricCrashReportingInteractor(preferences: self)
        
        analyticsReporter?.setupAnalytics()
        crashReporter?.setupCrashReporting()
    }
    
    // App Specific Code
    
    func installRootViewControllerIntoWindow(window: UIWindow) { }
    
}