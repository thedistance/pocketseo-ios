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

class MZExtensionURLDetailsViewController: MZURLDetailsViewController {
    
    /// Gets the single we're handling from the extension context.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // get the url from the extension
        extensionURL { (url) -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.urlString = url.absoluteString
            }
        }
        
        // configure the view
        urlInputView.hidden = true
        
        let cancelBBI = UIBarButtonItem(image: UIImage(named: "ic_clear"),
            style: .Plain,
            target: self,
            action: "cancel:")
        
        let openInAppBBI = UIBarButtonItem(title: LocalizedString(.URLExtensionOpenInAppButtonTitle),
            style: .Plain,
            target: self,
            action: "openInApp:")
        
        self.navigationItem.leftBarButtonItem = cancelBBI
        self.navigationItem.rightBarButtonItem = openInAppBBI
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(sender:AnyObject?) {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
//        self.extensionContext!.completeRequestReturningItems(<#T##items: [AnyObject]?##[AnyObject]?#>, completionHandler: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        self.extensionContext!.completeRequestReturningItems(self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    @IBAction func openInApp(sender:AnyObject?) {
        
    }

}
