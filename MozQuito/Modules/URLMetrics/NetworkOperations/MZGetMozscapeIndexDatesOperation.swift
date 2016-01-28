//
//  MZGetMozscapeIndexDatesOperation.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

class MZGetMozscapeIndexDatesOperation: MZAuthenticatedOperation {
    
    var success:((dates:MZMozscapeIndexedDates) -> Void)?
    
    init() {
        
        super.init(method: .GET,
            URLString: BaseURL.Mozscape + RequestPath.MozscapeIndexedDates,
            parameters: nil,
            encoding: .URL,
            headers: nil)
        
        self.responseSuccess = { (json) in
            
            do {
                let dates = try MZMozscapeIndexedDates(json: json)
                
                self.success?(dates:dates)
                
            } catch let error as NSError {
                self.finish([error])
            }
        }
    }
    
}