//
//  MZAppDependencies.swift
//  MozQuito
//
//  Created by Josh Campion on 22/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ViperKit
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

class MZAppDependencies : AppDependencies, _AppDependencies, PreferencesInteractor, RequestCache {
    
    typealias RequestCacheKeyType = RequestKeys
    
    let rootWireframe = MZRootWireframe()
    
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
        
        let statusView = ThemeView()
        statusView.backgroundColourStyle = .MainDark
        
        let statusFrame = CGRectMake(0, 0, window.frame.size.width, 20.0)
        statusView.frame = statusFrame
        statusView.autoresizingMask = .FlexibleWidth
        statusView.layer.zPosition = 10.0

        window.addSubview(statusView)
        
        window.rootViewController = rootWireframe.createRootViewController()
    }
    
}