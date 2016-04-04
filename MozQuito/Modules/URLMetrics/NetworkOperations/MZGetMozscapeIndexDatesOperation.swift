//
//  MZGetMozscapeIndexDatesOperation.swift
//  MozQuito
//
//  Created by Josh Campion on 28/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation
import PSOperations

class MZGetMozscapeIndexDatesOperation: GroupOperation {
    
    var success:((dates:MZMozscapeIndexedDates) -> Void)?

    private let lastDateOperation = MZGetMozscapeIndexDateOperation(requestPath: .MozscapeIndexedLastDate, jsonKey: "last_update")
    private let nextDateOperation = MZGetMozscapeIndexDateOperation(requestPath: .MozscapeIndexedNextDate, jsonKey: "next_update")
    
    private var lastDate:NSDate?
    private var nextDate:NSDate?
    
    init() {
        super.init(operations: [lastDateOperation, nextDateOperation])
    }
    
    override func operationDidFinish(operation: NSOperation, withErrors errors: [NSError]) {
        if operation == lastDateOperation {
            lastDate = lastDateOperation.foundDate
        }
        
        if operation == nextDateOperation {
            nextDate = nextDateOperation.foundDate
        }
    }
    
    override func finished(errors: [NSError]) {
        super.finished(errors)
        
        if let last = lastDate {
          
            let foundDates = MZMozscapeIndexedDates(last: last, next: nextDate)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.success?(dates: foundDates)
            })
        }
    }
}
    
class MZGetMozscapeIndexDateOperation: MZAuthenticatedOperation {
    
    var foundDate:NSDate?
    
    init(requestPath:RequestPath, jsonKey:String) {
        
        super.init(method: .GET,
            URLString: BaseURL.Mozscape + requestPath,
            parameters: nil,
            encoding: .URL,
            headers: nil)
        
        self.responseSuccess = { (json) in
            
            if let lastDateSecond = json[jsonKey].double {
                self.foundDate = NSDate(timeIntervalSince1970: lastDateSecond)
            }
            
            self.finish()
        }
    }
    
}