//
//  AppDelegate.swift
//  MozQuito
//
//  Created by Josh Campion on 21/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import Fabric
import ViperKit

//import PocketSEOEntities

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        #if DEBUG
            MZLocalization.dumpStringsFunction("MZLocalizedString", typed: "MZLocalizationKey", classed: "MZLocalization", filePath: "/Users/joshcampion/Documents/Client Repositories/MozQuito/MozQuitoEntities/Modules/Localization/MZLocalizedString.swift")
        #endif
        
        // Override point for customization after application launch.
        let dependencies = MZAppDependencies.sharedInstance()
        
        dependencies.crashReportingInteractor?.logToCrashReport("App Launched")
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.frame = UIScreen.mainScreen().bounds
        
        // set the root view controller via the app dependencies so log can be performed as to which vc to start from
        if let window = self.window {
            dependencies.installRootViewControllerIntoWindow(window)
        }
        
        if FabricInitialiser.kits.count > 0 {
            // starting Fabric has to be the last method
            Fabric.with(FabricInitialiser.kits)
        }
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

