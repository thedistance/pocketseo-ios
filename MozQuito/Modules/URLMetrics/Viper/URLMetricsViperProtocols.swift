//
//  URLMetricsViper.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import ViperKit

protocol URLMetricsInteractor: VIPERInteractor {
    
    /**
     
     Should call through to `getMetricsForURLString(_:)` after converting the URL to a valid `String` parameter.
     
     - parameter url: An `NSURL` object that can be converted as necessary to the parameter for `getMetricsForURLString(_:)`.
    */
    func getMetricsForURL(url:NSURL)
    
    /**

     Should query the network to get analytic metrics. On completion, will call either of:
     
     - `foundMetrics(_:)`
     - `failedToFindMetricsForURL(_:errors

     - parameter urlString: The url string to get metrics for. This can be be user entered or stripped from an `NSURL` from `getMetricsForURL(_:)`.
    */
    func getMetricsForURLString(urlString:String)
}

protocol URLMetricsPresenter: VIPERPresenter {
    
    /// Typically called from a `URLMetricsView` this should request metrics from the interactor for a known `NSURL` object.
    func requestMetricsForURL(url:NSURL)

    /// Typically called from a `URLMetricsView` this should request metrics from the interactor for a `String` typically user entered.
    func requestMetricsForURLString(urlString:String)
    
    /// Typically called from a `URLMetricsInteractor`, this should forward a successful request to the `URLMetricsView`.
    func foundMetrics(metrics:[MZMetric])
    
    /// Typically called from a `URLMetricsInteractor`, this should forward an unsuccessful request to the `URLMetricsView`.
    func failedToFindMetricsForURL(url:NSURL, withErrors:[NSError])
}

protocol URLMetricsView: VIPERView {
    
    /// Should update the UI to show the given metrics.
    func showMetrics(metrics:[MZMetric])
    
    /// Should update the UI to indicate a failed request.
    func showErrors(errors:[NSError], forURL:NSURL)
}

