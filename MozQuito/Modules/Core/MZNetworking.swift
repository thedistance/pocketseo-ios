//
//  MZNetworking.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import Alamofire

enum BaseURL:String, URLStringConvertible {
    
    case Mozscape = "https://lsapi.seomoz.com/linkscape"
    case Alexa = "http://data.alexa.com/data"
    
    var URLString:String {
        return rawValue
    }
}

/// Enum to define all of the api endpoints for the app. This can be used with `BaseURL` and the `+` operator to create a URLString.
enum RequestPath: String, URLStringConvertible {
    
    // --- URL Metrics --- \\
    
    case MozscapeURLMetrics = "url-metrics"
    case MozscapeIndexedDates = "metadata/last_update.json"
    
    var URLString:String {
        return rawValue
    }
}

func +(base:BaseURL, path:RequestPath) -> String {
    
    return base.URLString + "/" + path.URLString
}

func +(p1:RequestPath, p2:RequestPath) -> String {
    return p1.URLString + "/" + p2.URLString
}