//
//  File.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

class MZGetURLMetricsOperation: MZAuthenticatedOperation {
    
    var success:((metrics:[MZMetric]) -> Void)?
    
    init(requestURLString:String) {
        
        let requestString = "http://lsapi.seomoz.com/linkscape/url-metrics/" + requestURLString
        
        super.init(method: .GET,
            URLString: requestString,
            parameters: ["Cols": "103616137253"],
            encoding: .URL,
            headers: nil)
        
        self.responseSuccess = { (json) in
            
            print(json)
            
            self.success?(metrics: [])
        }
    }
    
}