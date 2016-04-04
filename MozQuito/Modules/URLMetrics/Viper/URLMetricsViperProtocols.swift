//
//  URLMetricsViper.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
//import ViperKit
//import PocketSEOEntities

/// Protocol defining the methods required on an object to provide network results to a `URLMetricsPresenter`.
protocol URLMetricsInteractor {
    
    /**

     Should query the network to get analytic metrics. On completion, will call either of:
     
     - `foundMozscapeMetrics(_:)`
     - `failedToFindMozscapeMetricWithErrors(_:)

     - parameter urlString: The url string to get metrics for. This can be be user entered.
    */
    func getMozscapeMetricsForURLString(urlString:String)
    
    /**
     
     Should query the network to get the indexed dates. On completion, will call `foundMozscapeIndexDates(_:)`. Errors for this will only be logged internally as this is supplementary data and separate errors will not be shown on the view.

     */
    func getMozscapeIndexDates()
    
    /**
     
     Should query the network to get page meta data. On completion, will call either of:
     
     - `foundPageMetaData(_:)`
     - `failedToFindPageMetaDataWithErrors(_:)
     
     - parameter urlString: The url string to get metrics for. This can be be user entered.
     */
    func getPageMetaDataForURLString(urlString:String)
    
    /**
     
     Should query the network to get page data from Amazon Alexa server. On completion, will call either of:
     
     - `foundAlexaData(_:)`
     - `failedToFindAlexaDataWithErrors(_:)
     
     - parameter urlString: The url string to get metrics for. This can be be user entered.
     */
    func getAlexaDataFromURLString(urlString:String)
}

/// Protocol defining the methods available to request by a `URLMetricsView`, and methods available to a `URLMetricsInteractor` to report results. All results should be reported to a `URLMetricsView`.
protocol URLMetricsPresenter {

    /// Typically called from a `URLMetricsView` this should refresh the metrics for a `String` typically user entered.
    func refreshMetricsForURLString(urlString:String)
    
    /// Typically called from a `URLMetricsView` this should request the multiple sources of metrics from the interactor for a `String` typically user entered.
    func requestMetricsForURLString(urlString:String)
    
    /// Typically called from a `URLMetricsInteractor`, this should forward a successful request to the `URLMetricsView`.
    func foundMozscapeMetrics(metrics:MZMozscapeMetrics)
    
    /// Typically called from a `URLMetricsInteractor`, this should forward an unsuccessful request to the `URLMetricsView`.
    func failedToFindMozscapeMetricWithErrors(errors:[NSError])
    
    /// Typically called from a `URLMetricsInteractor`, this should forward a successful request to the `URLMetricsView`.
    func foundPageMetaData(data:MZPageMetaData)
    
    /// Typically called from a `URLMetricsInteractor`, this should forward an unsuccessful request to the `URLMetricsView`.
    func failedToFindPageMetaDataWithErrors(errors:[NSError])
    
    /// Typically called from a `URLMetricsInteractor` or when data is in the cache, this should forward a successful request to the `URLMetricsView`.
    func foundMozscapeIndexDates(dates:MZMozscapeIndexedDates)
    
    /// Typically called from a `URLMetricsInteractor`, this should forward a successful request to the `URLMetricsView`.
    func foundAlexaData(data:MZAlexaData)
    
    /// Typically called from a `URLMetricsInteractor`, this should forward an unsuccessful request to the `URLMetricsView`.
    func failedToFindAlexaDataWithErrors(errors:[NSError])
    
}

/// Protocol defining the methods required on a object to respond to results from a `URLMetricsPresenter`.
protocol URLMetricsView: class {
    
    /// Should update the UI to show the given metrics.
    func showMozscapeMetrics(metrics:MZMozscapeMetrics)

    /// Should update the UI to show the given meta data.
    func showPageMetaData(data:MZPageMetaData)
    
    /// Should update the UI to show the given dates.
    func showMozscapeIndexedDates(dates:MZMozscapeIndexedDates)
    
    /// Should update the UI to show the given data from Alexa.
    func showAlexaData(data:MZAlexaData)
    
    /// Should update the UI to indicate a failed request to Mozscape.
    func showMozscapeMetricsErrors(errors:[NSError])

    /// Should update the UI to indicate a failed request to get meta data.
    func showPageMetaDataErrors(errors:[NSError])
    
    /// Should update the UI to indicate a failed request to get meta data.
    func showAlexaDataErrors(errors:[NSError])
    
}

