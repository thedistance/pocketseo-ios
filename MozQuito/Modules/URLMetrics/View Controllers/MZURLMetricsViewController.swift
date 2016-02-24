//
//  MZURLMetricsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import TheDistanceCore
import ViperKit
import StackView

class MZURLMetricsViewController: UIViewController, URLMetricsView {

    @IBOutlet weak var distanceView:MZDistanceView?
    
    var presenter:MZURLMetricsPresenter<MZURLMetricsViewController>?
    
    var urlString:String? {
        didSet {
            
            pageMetaData = nil
            mozscapeMetrics = nil
            mozscapeIndexedDates = nil
            alexaData = nil
            
            metricsView?.metricsStack.pageMetaDataView.metaStack.configureAsExpanded(false)
            
            if let str = urlString {
                presenter?.requestMetricsForURLString(str)
            }
        }
    }
    
    var pageMetaData:MZPageMetaData? {
        didSet {
            metricsView?.pageMetaData = pageMetaData
        }
    }
    
    var mozscapeMetrics:MZMozscapeMetrics? {
        didSet {
            metricsView?.mozscapeMetrics = mozscapeMetrics
        }
    }
    
    var mozscapeIndexedDates:MZMozscapeIndexedDates? {
        didSet {
            metricsView?.mozscapeIndexedDates = mozscapeIndexedDates
        }
    }
    
    var alexaData:MZAlexaData? {
        didSet {
            metricsView?.alexaData = alexaData
        }
    }
    
    @IBOutlet weak var metricsView:MZURLMetricsView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // re-set the properties to assign to the views incase the presenter request finished before viewDidLoad(_:)
        let meta = pageMetaData
        pageMetaData = meta
        
        #if DEBUG || BETA_TESTING
            
        // set up the test view
        let tapper = UITapGestureRecognizer(target: self, action: "logoTripleTapped:")
        tapper.numberOfTouchesRequired = 1
        tapper.numberOfTapsRequired = 3
        distanceView?.tdStack.logoImageView.userInteractionEnabled = true
        distanceView?.tdStack.logoImageView.addGestureRecognizer(tapper)
        
        #endif
    }
    
    func logoTripleTapped(sender:AnyObject?) {
        
        let testVC = MZStoryboardLoader.instantiateViewControllerForIdentifier(.TestVC, bundle: NSBundle(forClass: TestAnalyticsViewController.self))
        let testNav = UINavigationController(rootViewController: testVC)
        
        if let dv = distanceView {
            self.presentViewController(testNav, fromSourceItem: .View(dv))
        }
    }

    // MARK: - URLMetricsView

    // MARK: Meta Data
    
    func showPageMetaData(data: MZPageMetaData) {
        pageMetaData = data
    }
    
    func showPageMetaDataErrors(errors: [NSError]) {
        
    }
    
    // MARK: Mozscape
    
    func showMozscapeMetrics(metrics: MZMozscapeMetrics) {
        mozscapeMetrics = metrics
    }
    
    func showMozscapeMetricsErrors(errors: [NSError]) {
        
    }
    
    func showMozscapeIndexedDates(dates: MZMozscapeIndexedDates) {
        mozscapeIndexedDates = dates
    }
    
    // MARK: Alexa
    
    func showAlexaData(data: MZAlexaData) {
        alexaData = data
    }
    
    func showAlexaDataErrors(errors: [NSError]) {
        
    }
    
    func showTest() {
        MZStoryboardLoader.instantiateViewControllerForIdentifier(.TestVC, bundle: NSBundle(forClass: TestAnalyticsViewController.self))
    }
    
}
