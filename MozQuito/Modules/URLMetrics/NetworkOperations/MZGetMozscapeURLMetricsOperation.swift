//
//  File.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import SwiftyJSON
//import PocketSEOEntities

class MZGetMozscapeURLMetricsOperation: MZAuthenticatedOperation {
    
    var success:((metrics:MZMozscapeMetrics) -> Void)?
    
    init(requestURLString:String) {
        
        let requestString = BaseURL.Mozscape + RequestPath.MozscapeURLMetrics + "/\(requestURLString)"
        
        let cols:[MZMetricKey] = [.Title, .CanonicalURL, .HTTPStatusCode, .DomainAuthority, .PageAuthority, .SpamScore, .EstablishedLinksRootDomains, .EstablishedLinksTotalLinks]
        let colsValue = cols.map({ $0.colValue }).reduce(0, combine: + )
        
        super.init(method: .GET,
            URLString: requestString,
            parameters: ["Cols": "\(colsValue)"],
            encoding: .URL,
            headers: nil)
        
        self.responseSuccess = { (json) in
            
            do {
                let metrics = try MZMozscapeMetrics(json: json)
                
                self.success?(metrics:metrics)
                
            } catch let error as NSError {
                self.finish([error])
            }
        }
    }
    
}