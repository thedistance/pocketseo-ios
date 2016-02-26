//
//  ActionViewController.swift
//  URLDetailsExtension
//
//  Created by Josh Campion on 25/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import MobileCoreServices
import JCLocalization
import DeviceKit
import Fabric

class MZExtensionURLDetailsViewController: MZURLDetailsViewController, MZDistanceStackDelegate {
    
    let rootWireframe = MZRootWireframe()
    
    // This is the launch point for the extension, application(_:didFinishLaunchingWithOptions:) does not get all in this context
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let _ = MZThemeVendor.shared()
        
        // Override point for customization after application launch.
        let dependencies = MZAppDependencies.sharedInstance()
        
        dependencies.crashReportingInteractor?.logToCrashReport("App Extension Launched")

        // set the global session scope variable
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(GAIFields.customDimensionForIndex(AnalyticsCustomMetric.DeviceType.rawValue), value: Device().description)
        tracker.set(GAIFields.customDimensionForIndex(AnalyticsCustomMetric.ContextType.rawValue), value: "Quick Lookup")
        
        if FabricInitialiser.kits.count > 0 {
            // starting Fabric has to be the last method
            Fabric.with(FabricInitialiser.kits)
        }
        
        // configure the presenter
        rootWireframe.configureChildViewControllersForURLDetailsViewController(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PocketSEO"
        
        // get the url from the extension
        extensionURL { (url) -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.urlString = url.absoluteString
            }
        }
        
        // configure the distance stack
        metricsVC.distanceView?.tdStack.delegate = self
        
        // configure the view
        let cancelBBI = ThemeBarButtonItem(image: UIImage(named: "ic_clear"),
            style: .Plain,
            target: self,
            action: "cancel:")
        
        let openInAppBBI = ThemeBarButtonItem(title: LocalizedString(.URLExtensionOpenInAppButtonTitle),
            style: .Plain,
            target: self,
            action: "openInApp:")
        
        openInAppBBI.textStyle = .Body2
        
        self.navigationItem.leftBarButtonItem = cancelBBI
        self.navigationItem.rightBarButtonItem = openInAppBBI
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    }

    // MARK: - Actions

    @IBAction func cancel(sender:AnyObject?) {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
//        self.extensionContext!.completeRequestReturningItems(<#T##items: [AnyObject]?##[AnyObject]?#>, completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    @IBAction func openInApp(sender:AnyObject?) {
        
        let event = AnalyticEvent(category: .DataRequest, action: .quickLookupOpenInApp, label: nil)
        AppDependencies.sharedDependencies().analyticsInteractor?.sendAnalytic(event)
        
    }
    
    // MARK: - Distance Delegate
    
    func distanceStackRequestsSendFeedback(stack: MZDistanceStack, sender: UIButton) {
        
    }
    
    func distanceStackRequestsGetInTouch(stack: MZDistanceStack, sender: UIButton) {
        
    }
    
    func distanceStackRequestsWebsite(stack: MZDistanceStack, sender: UIButton) {
        
        guard let url = NSURL(string: LocalizedString(.TheDistanceContactWebsiteURL)) else { return }
        
        let websiteEvent = AnalyticEvent(category: .Meta, action: .viewDistanceWebsite, label: nil)
        AppDependencies.sharedDependencies().analyticsInteractor?.sendAnalytic(websiteEvent)
        
        let item = NSExtensionItem()
        item.attachments = [url]
        self.extensionContext!.completeRequestReturningItems([item], completionHandler: nil)
    }

    // MARK: - Extension
    
    /// Gets the single url we're handling from the extension context.
    func extensionURL(completion:(url:NSURL) -> ())  {
        
        var urlFound = false
        for item: AnyObject in self.extensionContext!.inputItems {
            let inputItem = item as! NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    
                    // This is a URL. We'll load it, then return it
                    itemProvider.loadItemForTypeIdentifier(kUTTypeURL as String, options: nil, completionHandler: { (urlObject, error) in
                        
                        if let url = urlObject as? NSURL {
                            completion(url: url)
                        }
                    })
                    
                    urlFound = true
                    break
                }
            }
            
            if (urlFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
    }
}
