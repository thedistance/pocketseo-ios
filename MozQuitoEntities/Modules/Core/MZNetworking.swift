//
//  MZNetworking.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import Alamofire

public enum BaseURL:String, URLStringConvertible {
    
    case Mozscape = "https://lsapi.seomoz.com/linkscape"
    case Alexa = "http://data.alexa.com/data"
    
    public var URLString:String {
        return rawValue
    }
}

/// Enum to define all of the api endpoints for the app. This can be used with `BaseURL` and the `+` operator to create a URLString.
public enum RequestPath: String, URLStringConvertible {
    
    // --- URL Metrics --- \\
    
    case MozscapeURLMetrics = "url-metrics"
    case MozscapeIndexedLastDate = "metadata/last_update.json"
    case MozscapeIndexedNextDate = "metadata/next_update.json"
    
    public var URLString:String {
        return rawValue
    }
}

public func +(base:BaseURL, path:RequestPath) -> String {
    
    return base.URLString + "/" + path.URLString
}

public func +(p1:RequestPath, p2:RequestPath) -> String {
    return p1.URLString + "/" + p2.URLString
}