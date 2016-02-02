//
//  MZRootWireframe.swift
//  MozQuito
//
//  Created by Josh Campion on 02/02/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit

import PocketSEOEntities
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
        
        let vc = MZStoryboardLoader.instantiateViewControllerForIdentifier(.URLDetailsVC)
        
        let urlMetricsVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.URLMetricsVC)
        urlMetricsVC.title = MZLocalizedString(.URLMetricsTitle)
        
        if let metricsVC = urlMetricsVC as? MZURLMetricsViewController {
            metricsVC.presenter = MZURLMetricsPresenter.configuredPresenterForView(metricsVC)
        }
        
        if let detailsVC = vc as? MZURLDetailsViewController {
            detailsVC.viewControllers = [urlMetricsVC]
        }

        return vc
    }
}