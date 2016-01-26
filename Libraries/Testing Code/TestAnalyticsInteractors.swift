//
//  TestAnalyticsInteractors.swift
//  Interchange
//
//  Created by Josh Campion on 30/07/2015.
//  Copyright © 2015 Interchange Management Ltd. All rights reserved.
//

import Foundation

/// PreferencesInteractor for testing. This always returns true and prevents tests from needing to configure NSUserDefaults
final class TestPreferences:PreferencesInteractor {
    
    static func setDefaultPreferences() { }
    
    func canSendAnalytics() -> Bool {
        return true
    }
    
    func canSendCrashReports() -> Bool {
        return false
    }
    
}

/// CrashReportingInteractor for testing. Logs crash messages to and internal array of strings so it can be tested.
final class TestCrashInteractor: CrashReportingInteractor {
    
    static private let _sharedCrash = TestCrashInteractor()
    
    var preferences:PreferencesInteractor?
    
    /// Internal variable for saving the log messages.
    var messages = [String]()
    
    func setupCrashReporting() {
        // reset the messages store
         messages = [String]()
    }
    
    func logToCrashReport(message: String) {
        messages.append(message)
    }
    
    /// Public readonly accessor for private store.
    func crashLogMessages() -> [String] {
        return messages
    }
    
    func simulateCrash() {
        assertionFailure("Simulated Crash!")
    }
}


/// Logs events into an internal array to ensure analytics interactor events are correctly called from other VIPERInteractors in the project
final class TestAnalyticsInteractor:AnalyticsInteractor {
    
    static private let _sharedAnalytics = TestAnalyticsInteractor()
    
    var preferences:PreferencesInteractor?
    
    /// Internal variable for saving the events that are sent.
    private var trackedEvents = [AnalyticEvent]()
    
    // analytics is always enabled in test mode
    func enableAnalytics(enable: Bool) { }
    
    func setupAnalytics() {
        // reset the tracking
        trackedEvents = [AnalyticEvent]()
    }
    
    func sendAnalytic(event: AnalyticEvent, asNewSession session: AnalyticSession? = nil) {
        
        // append the with new events.
        var toRecord = event
        if let s = session {
            toRecord.addInfo("session", value: s)
            
            trackedEvents = [AnalyticEvent]()
        }
        
        trackedEvents.append(toRecord)
    }
    
    /// Public readonly accessor for private store.
    func events() -> [AnalyticEvent] {
        return trackedEvents
    }
    
}