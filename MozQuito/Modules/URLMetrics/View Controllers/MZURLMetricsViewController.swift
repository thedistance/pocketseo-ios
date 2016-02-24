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
    @IBOutlet weak var emptyView:UIView?
    
    var presenter:MZURLMetricsPresenter<MZURLMetricsViewController>?
    
    var urlString:String? {
        didSet {
            
            pageMetaData = nil
            mozscapeMetrics = nil
            mozscapeIndexedDates = nil
            alexaData = nil
            
            let validURL = !(urlString?.isEmpty ?? false)
            emptyView?.hidden = validURL
            
            if let mv = metricsView {
                
                // show the panels as they are initially hidden for the empty view
                // hide the metrics stacks
                if let svs = metricsView?.metricsStack.stack.arrangedSubviews {
                    for sv in svs {
                        sv.hidden = !validURL
                    }
                }
                
                // reset each panel to start loading
                let expandingStacks = [mv.metricsStack.pageMetaDataView,
                    mv.metricsStack.mozDataView,
                    mv.metricsStack.alexaDataView]
                    .flatMap({ $0.stack as? MZExpandingStack })
                
                for s in expandingStacks {
                    s.state = .Loading
                }
            }
            
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
        
        // hide the metrics stacks
        if let svs = metricsView?.metricsStack.stack.arrangedSubviews {
            for sv in svs {
                sv.hidden = true
            }
        }
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
        
        (metricsView?.metricsStack.pageMetaDataView.stack as? MZExpandingStack)?.state = .Success
    }
    
    func showPageMetaDataErrors(errors: [NSError]) {
        showErrors(errors, forPanel: metricsView?.metricsStack.pageMetaDataView)
    }
    
    // MARK: Mozscape
    
    func showMozscapeMetrics(metrics: MZMozscapeMetrics) {
        mozscapeMetrics = metrics
        
        (metricsView?.metricsStack.mozDataView.stack as? MZExpandingStack)?.state = .Success
    }
    
    func showMozscapeMetricsErrors(errors: [NSError]) {
        showErrors(errors, forPanel: metricsView?.metricsStack.mozDataView)
    }
    
    func showMozscapeIndexedDates(dates: MZMozscapeIndexedDates) {
        mozscapeIndexedDates = dates
    }
    
    // MARK: Alexa
    
    func showAlexaData(data: MZAlexaData) {
        alexaData = data
        
        (metricsView?.metricsStack.alexaDataView.stack as? MZExpandingStack)?.state = .Success
    }
    
    func showAlexaDataErrors(errors: [NSError]) {
        showErrors(errors, forPanel: metricsView?.metricsStack.alexaDataView)
    }
    
    func showErrors(errors:[NSError], forPanel panel:MZPanel?) {
        if let e = errors.first {
            (panel?.stack as? MZExpandingStack)?.state = .Error(e)
        }
    }
    
    func showTest() {
        MZStoryboardLoader.instantiateViewControllerForIdentifier(.TestVC, bundle: NSBundle(forClass: TestAnalyticsViewController.self))
    }
    
}
