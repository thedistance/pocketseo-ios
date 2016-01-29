//
//  MZURLMetricsViewController.swift
//  MozQuito
//
//  Created by Josh Campion on 29/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import UIKit
import TheDistanceCore
import MozQuitoViews
import MozQuitoEntities

class MZURLMetricsViewController: UIViewController, URLMetricsView {

    var presenter:MZURLMetricsPresenter<MZURLMetricsViewController>?
    
    var urlString:String? {
        didSet {
            if let str = urlString {
                presenter?.requestMetricsForURLString(str)
            }
        }
    }
    
    @IBOutlet weak var metricsView:MZURLMetricsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.urlString = "https://thedistance.co.uk"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - URLMetricsView

    // MARK: Meta Data
    
    func showPageMetaData(data: MZPageMetaData) {
        metricsView.pageMetaData = data
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
