//
//  MZRootWireframe.swift
//  MozQuito
//
//  Created by Josh Campion on 02/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import JCLocalization
import TheDistanceCore
import JCPageViewController

class MZRootWireframe {
    
    func getRootViewController() -> UIViewController? {
        return UIApplication.sharedApplication().keyWindow?.rootViewController
    }
    
    func setRootViewController(vc:UIViewController) {
        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
    }
    
    func createRootViewController() -> UIViewController {
        
        if isTesting {
            // return a blank VC to ensure no code is running to interfere with the tests
            return UIViewController()
        }
        
        let detailsVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.URLDetailsVC) as! MZURLDetailsViewController
        
        let urlMetricsVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.URLMetricsVC) as! MZURLMetricsViewController
        urlMetricsVC.title = LocalizedString(.URLMetricsTitle).uppercaseString
        urlMetricsVC.presenter = MZURLMetricsPresenter.configuredPresenterForView(urlMetricsVC)
        
        let linksVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.URLLinksVC)
        linksVC.title = LocalizedString(.URLLinksTitle).uppercaseString
        
        detailsVC.metricsVC = urlMetricsVC
        detailsVC.linksVC = linksVC
        
        return detailsVC
    }
}