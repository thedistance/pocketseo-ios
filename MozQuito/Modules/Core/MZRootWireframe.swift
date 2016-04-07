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
    
    var apiManager:APIManager
    var urlStore:URLStore
    
    init(urlStore:URLStore) {
        self.urlStore = urlStore
        apiManager = APIManager(urlStore: urlStore)
    }
    
    func createRootViewController() -> UIViewController {
        
        if isTesting {
            // return a blank VC to ensure no code is running to interfere with the tests
            return UIViewController()
        }
        
        let detailsVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.URLInputDetailsVC) as! MZURLDetailsViewController
        
        configureChildViewControllersForURLDetailsViewController(detailsVC)
        
        return detailsVC
    }
    
    func configureChildViewControllersForURLDetailsViewController(detailsVC:MZURLDetailsViewController) {
        
        let urlMetricsVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.URLMetricsVC) as! MZURLMetricsViewController
        urlMetricsVC.title = LocalizedString(.URLMetricsTitle).uppercaseString
        urlMetricsVC.presenter = MZURLMetricsPresenter.configuredPresenterForView(urlMetricsVC)
        
        let linksVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.URLLinksVC) as! MZLinksViewController
        linksVC.title = LocalizedString(.URLLinksTitle).uppercaseString
        linksVC.viewModel = MozscapeLinksViewModel(apiManager: self.apiManager)
        
        detailsVC.metricsVC = urlMetricsVC
        detailsVC.linksVC = linksVC
        
        
    }
}