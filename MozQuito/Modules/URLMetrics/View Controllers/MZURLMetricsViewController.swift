//
//  MZURLMetricsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import TheDistanceCore
//import ViperKit
import StackView

class MZURLMetricsViewController: UIViewController, URLMetricsView {

    @IBOutlet weak var distanceView:MZDistanceView?
    @IBOutlet weak var noInputContainer:UIView?
    let noInputView = NoInputView()
    var presenter:MZURLMetricsPresenter<MZURLMetricsViewController>?
    
    var urlString:String? {
        didSet {
            
            pageMetaData = nil
            mozscapeMetrics = nil
            mozscapeIndexedDates = nil
            
            let validURL = !(urlString?.isEmpty ?? false)
            noInputView.hidden = validURL
            contentToBottomConstraint?.priority = validURL ? 990 : 740
            
            for p in metricsViews {
                p?.hidden = !validURL
            }
            
            if validURL {
            
                for p in metricsViews {
                    (p?.stack as? MZExpandingStack)?.state = .Loading
                }
                
                if let str = urlString {
                    
                    if str != oldValue {
                        presenter?.requestMetricsForURLString(str)
                    } else {
                        presenter?.refreshMetricsForURLString(str)
                    }
                }
            }
        }
    }
    
    var pageMetaData:MZPageMetaData? {
        didSet {
            metaDataView?.metaStack.pageMetaData = pageMetaData
        }
    }
    
    var mozscapeMetrics:MZMozscapeMetrics? {
        didSet {
            mozscapeView?.dataStack.data = mozscapeMetrics
        }
    }
    
    var mozscapeIndexedDates:MZMozscapeIndexedDates? {
        didSet {
            mozscapeView?.dataStack.indexedStack.dates = mozscapeIndexedDates
        }
    }
    
    @IBOutlet weak var contentToBottomConstraint:NSLayoutConstraint?
    //@IBOutlet weak var contentHeightConstraint:NSLayoutConstraint?
    @IBOutlet weak var metaDataView:MZPageMetaDataView?
    @IBOutlet weak var mozscapeView:MZMozscapeMetricsView?

    
    var metricsViews:[MZPanel?] {
        return [metaDataView, mozscapeView]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // re-set the properties to assign to the views incase the presenter request finished before viewDidLoad(_:)
        let meta = pageMetaData
        pageMetaData = meta
        
        // hide the metrics stacks
        for sv in metricsViews {
            sv?.hidden = true
        }
        
        if let container = noInputContainer {
            container.addSubview(noInputView, centeredOn: container)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure TheDistanceStack based on context
        if extensionContext != nil {
            distanceView?.distanceStack = MZDistanceExtensionStack()
        } else {
            distanceView?.distanceStack = MZDistanceApplicationStack()
        }
        
        #if DEBUG || BETA_TESTING
            // set up the test view
            let tapper = UITapGestureRecognizer(target: self, action: #selector(MZURLMetricsViewController.logoTripleTapped(_:)))
            tapper.numberOfTouchesRequired = 1
            tapper.numberOfTapsRequired = 3
            distanceView?.distanceStack?.logoImageView.userInteractionEnabled = true
            distanceView?.distanceStack?.logoImageView.addGestureRecognizer(tapper)
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
        
        metaDataView?.metaStack.state = .Success
    }
    
    func showPageMetaDataErrors(errors: [NSError]) {
        showErrors(errors, forPanel: metaDataView)
    }
    
    // MARK: Mozscape
    
    func showMozscapeMetrics(metrics: MZMozscapeMetrics) {
        mozscapeMetrics = metrics
        
        mozscapeView?.dataStack.state = .Success
    }
    
    func showMozscapeMetricsErrors(errors: [NSError]) {
        showErrors(errors, forPanel: mozscapeView)
    }
    
    func showMozscapeIndexedDates(dates: MZMozscapeIndexedDates) {
        mozscapeIndexedDates = dates
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
