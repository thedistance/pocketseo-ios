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

import Components

class MZExtensionURLDetailsViewController: MZURLDetailsViewController, MZDistanceExtensionStackDelegate {
    
    let rootWireframe = MZRootWireframe(urlStore: LiveURLStore())
    
    // This is the launch point for the extension, application(_:didFinishLaunchingWithOptions:) does not get all in this context
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let _ = MZThemeVendor.shared()
        
        // Override point for customization after application launch.
        let dependencies = MZAppDependencies.sharedDependencies()
        
        dependencies.crashReporter?.logToCrashReport("App Extension Launched")

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
        
        // configure the view
        let cancelBBI = ThemeBarButtonItem(image: UIImage(named: "ic_clear"),
            style: .Plain,
            target: self,
            action: #selector(MZExtensionURLDetailsViewController.cancel(_:)))
        
        self.navigationItem.leftBarButtonItem = cancelBBI
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // configure the distance stack
        (metricsVC.distanceView?.distanceStack as? MZDistanceExtensionStack)?.delegate = self
        
        // get the url from the extension
        extensionURL { (url) -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.urlString = url.absoluteString
            }
        }
    }

    // MARK: - Actions

    @IBAction func cancel(sender:AnyObject?) {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
//        self.extensionContext!.completeRequestReturningItems(<#T##items: [AnyObject]?##[AnyObject]?#>, completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    @IBAction func openInApp(sender:AnyObject?) {
        
        guard let urlString = self.urlString?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()),
            let appURL = NSURL(string: "pocketseo://?urlString=\(urlString)")
            else { return }
        
        let event = AnalyticEvent(category: .DataRequest, action: .quickLookupOpenInApp, label: nil)
        AppDependencies.sharedDependencies().analyticsReporter?.sendAnalytic(event)
        
        var responder = self.nextResponder()
        while responder != nil {
            
            if responder is UIApplication {
                break
            } else {
                responder = responder?.nextResponder()
            }
        }
        
        if let application = responder as? UIApplication {
            application.performSelector("openURL:", withObject: appURL)
            return
        }
    }
    
    // MARK: - Distance Delegate
    
    func distanceStackRequestsOpenInApp(stack: MZDistanceStack, sender: UIButton) {
        openInApp(sender)
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
    
    override func configureFilterVisibility() {
        
        if self.navigationItem.rightBarButtonItem == nil {
            // add filter bbi
            
            let bbi = UIBarButtonItem(image: UIImage(named: "ic_filter_list"), style: .Plain, target: linksVC, action: #selector(MZLinksViewController.filterTapped(_:)))
            self.navigationItem.setRightBarButtonItem(bbi, animated: true)
            
        } else {
            // hide filter
            self.navigationItem.setRightBarButtonItem(nil, animated: true)
        }
        
    }
}
