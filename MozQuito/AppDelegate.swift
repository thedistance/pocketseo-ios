//
//  AppDelegate.swift
//  MozQuito
//
//  Created by Josh Campion on 21/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import Fabric
import Components
import DeviceKit

class MZApplicationAppDependencies: MZAppDependencies {
    
    let rootWireframe = MZApplicationRootWireframe()
    
    override func installRootViewControllerIntoWindow(window: UIWindow) {
        window.rootViewController = rootWireframe.createRootViewController()
    }
    
    func openURL(url:NSURL) -> Bool {
        
        guard let urlString = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)?
            .queryItems?
            .filter({ $0.name == "urlString" })
            .first?
            .value?
            .stringByRemovingPercentEncoding
            else { return false }
        
        // This will need to be more complex when the view hierarchy is more complex
        if let urlDetailsVC = rootWireframe.getRootViewController() as? MZURLDetailsViewController {
            urlDetailsVC.urlString = urlString
            urlDetailsVC.dismissViewControllerAnimated(true, completion: nil)
        }
        
        return true
    }
}

class MZApplicationRootWireframe: MZRootWireframe {
    
    func getRootViewController() -> UIViewController? {
        return UIApplication.sharedApplication().keyWindow?.rootViewController
    }
    
    func setRootViewController(vc:UIViewController) {
        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let _ = MZThemeVendor.shared()
        
        // Override point for customization after application launch.
        let dependencies = MZApplicationAppDependencies.sharedDependencies()
        
        dependencies.crashReporter?.logToCrashReport("App Launched")
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.frame = UIScreen.mainScreen().bounds
        
        // set the root view controller via the app dependencies so log can be performed as to which vc to start from
        if let window = self.window {
            dependencies.installRootViewControllerIntoWindow(window)
        }
        
        // set the global session scope variable
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(GAIFields.customDimensionForIndex(AnalyticsCustomMetric.DeviceType.rawValue), value: Device().description)
        tracker.set(GAIFields.customDimensionForIndex(AnalyticsCustomMetric.ContextType.rawValue), value: "In App")
        
        if FabricInitialiser.kits.count > 0 {
            // starting Fabric has to be the last method
            Fabric.with(FabricInitialiser.kits)
        }
        
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return MZApplicationAppDependencies.sharedDependencies().openURL(url)
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return MZApplicationAppDependencies.sharedDependencies().openURL(url)
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

