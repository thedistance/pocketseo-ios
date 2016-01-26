//
//  ViperTester.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

// MARK: - VIPERTester

/// Protocol that simplifies adding completions blocks to VIPER protocol classes for testing. Typically a VIPER presenter adopts this, and the tests call one presenter method and tests the results are correct via the relevant completion.  Only a single expectation is allowed as tests should only test a single method at a time.
protocol VIPERTester {
    
    /// The expectation to wait for. This is clear in completeExpectation(_:completion:)
    var expectation:XCTestExpectation? { get set }
    
    /**
     
     Convenience method. The default implementation completes the expectation, calling the complete block and setting both the expectation variable and the completion variable to nil. It is called on the thread the method is called from, ensuring the tests are aware of any thread changes.
     
     - parameter expectation: The expectation to .fulfill() and clear.
     - parameter completion: The block to run. This is where custom code can be added.
     */
    func completeExpectation<T>(inout expectation:XCTestExpectation?, inout completion:T?, complete:() -> ())
}

extension VIPERTester {
    
    func completeExpectation<T>(inout expectation:XCTestExpectation?, inout completion:T?, complete:() -> ()) {
        
        if let e = self.expectation {
            
            e.fulfill()
            expectation = nil
            
            complete()
            
            completion = nil
        }
    }
}

// MARK: - Testing Dependencies

let defaultTimeOut:NSTimeInterval = 15.0

/// Protocol for all XCTestCase subclasses for Interchange. Adds default method for configuring `ICAppDependencies` to be for the testing site.
protocol ViperTesting:class {
    
    /// Sets up the ICAppDependencies singleton for testing.
    func setupDependencies()
}

extension ViperTesting {
    
    func setupDependencies() {
        let dependencies = ICAppDependencies.sharedDependencies
        
        dependencies.preferencesInteractor = TestPreferences.self
        dependencies.analyticsInteractor = TestAnalyticsInteractor.self
        
        let url = NSBundle(forClass: self.dynamicType).URLForResource("SiteInfo-Testing", withExtension: "json")!
        dependencies.space = ICAppDependencies.sharedDependencies.getSpace(url)
        
    }
    
}