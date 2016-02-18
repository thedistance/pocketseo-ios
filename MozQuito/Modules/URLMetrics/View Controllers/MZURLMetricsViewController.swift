//
//  MZURLMetricsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import TheDistanceCore
//import PocketSEOViews
//import PocketSEOEntities

class MZURLMetricsViewController: UIViewController, URLMetricsView {

    var presenter:MZURLMetricsPresenter<MZURLMetricsViewController>?
    
    var urlString:String? {
        didSet {
            
            pageMetaData = nil
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
    
    @IBOutlet weak var metricsView:MZURLMetricsView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // re-set the properties to assign to the views incase the presenter request finished before viewDidLoad(_:)
        let meta = pageMetaData
        pageMetaData = meta
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
        print(metrics)
    }
    
    func showMozscapeMetricsErrors(errors: [NSError]) {
        
    }
    
    func showMozscapeIndexedDates(dates: MZMozscapeIndexedDates) {
        print(dates)
    }
    
    // MARK: Alexa
    
    func showAlexaData(data: MZAlexaData) {
        print(data)
    }
    
    func showAlexaDataErrors(errors: [NSError]) {
        
    }
    
    
}
