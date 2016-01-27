//
//  AnalyticsInteractors.swift
//  MozQuito
//
//  Created by Josh Campion on 22/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import Fabric
import Crashlytics

import ViperKit

// APP SPECIFIC
let GoogleAnalyticsTrackingIDLive = "UA-72773655-3"
let GoogleAnalyticsTrackingIDStaging = "UA-72773655-2"

/// Helper class to allow submodules within Fabric to be registered for starting, allowing the final line of `application(_:didFinishLaunchingWithOptions:)` to be called in a clean, but dynamic manner.
final class FabricInitialiser {
    
    /// The Fabric kits to be started at the end of `application(_:didFinishLaunchingWithOptions:)` using `Fabric.with(_:)`.
    static var kits = [AnyObject]()
}

/**
 
 Default implementation of crash reporting using Crashlytics, through Fabric. This class should not be subclassed and is therefore 'final' for optimization.
 
 Crashlytics is not initialised when in `DEBUG` mode. If not in `DEBUG` the `preferences` interactor is queried. If the user has given permission `Crashlytics()` is appended to the `FabricInitialiser.kits` array to be initialised at the end of `application(_:didFinishLaunchingWithOptions:)`.
 */
final class FabricCrashReportingInteractor: CrashReportingInteractor
{
    var preferences:PreferencesInteractor?
    
    func setupCrashReporting() {
        #if DEBUG
            print("Not starting Crashlytics in Debug")
        #else
            if let canSend = preferences?.canSendCrashReports() where canSend {
                FabricInitialiser.kits.append(Crashlytics())
            }
        #endif
    }
    
    func simulateCrash() {
        Crashlytics.sharedInstance().crash()
    }
    
    func logToCrashReport(message:String) {
        #if !DEBUG
            CLSLogv(message, getVaList([]))
        #else
            print(message)
        #endif
    }
    
    func logNonFatalError(error: NSError) {
        
    }
}

/// Default implementation of analytics using Google Analytics. This class should not be subclassed and is therefore 'final' for optimization.
final class GoogleAnalyticsInteractor:AnalyticsInteractor {
    
    var preferences:PreferencesInteractor?
    
    func enableAnalytics(enable: Bool) {
        GAI.sharedInstance().optOut = !enable
    }
    
    func setupAnalytics() {
        
        #if DEBUG || BETA_TESTING
            let trackingID = GoogleAnalyticsTrackingIDStaging
        #else
            let trackingID = GoogleAnalyticsTrackingIDLive
        #endif
        
        // Configure tracker from GoogleService-Info.plist.
        GAI.sharedInstance().defaultTracker = GAI.sharedInstance().trackerWithTrackingId(trackingID)
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        
        #if DEBUG
            gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
        #endif
    }
    
    func sendAnalytic(event: AnalyticEvent, asNewSession session:AnalyticSession? = nil) {
        
        let builder:GAIDictionaryBuilder
        let tracker = GAI.sharedInstance().defaultTracker
        
        if event.isCategory(.Screens, andAction: .Viewed) {
            // this is a screen view
            tracker.set(kGAIScreenName, value: event.label)
            builder = GAIDictionaryBuilder.createScreenView()
            
        } else {
            // build a standard event
            let value = event.userInfo["value"] as? NSNumber
            
            builder = GAIDictionaryBuilder.createEventWithCategory(event.category,
                action: event.action,
                label: event.label,
                value: value)
        }
        
        if session != nil {
            builder.set("start", forKey: kGAISessionControl)
            
            // configure any sesion scope custom dimensions here
            // set the device name etc.
        }
        
        AppDependencies.sharedDependencies().crashReportingInteractor?.logToCrashReport(event.description)
        
        // send the event
        tracker.send(builder.build() as [NSObject: AnyObject])
    }
    
    func sendScreenView(screenName: String) {
        let screenEvent = AnalyticEvent(screenName: screenName)
        sendAnalytic(screenEvent)
    }
}
