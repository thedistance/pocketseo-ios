//
//  MZErrors.swift
//  MozQuito
//
//  Created by Josh Campion on 27/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

enum MZErrorDomain:String {
    case InitError
    case MozscapeError
    case HTMLError
    case XMLError
}

enum MZErrorCode:Int {
    case UnexpectedResponse
}

extension NSError {
    
    convenience init(InitUnexpectedResponseWithDescription descr: String) {
        self.init(domain: .InitError, code:.UnexpectedResponse, userInfo: [NSLocalizedDescriptionKey: descr])
    }
    
    convenience init(domain:MZErrorDomain, code:MZErrorCode, userInfo:[NSObject:AnyObject]?) {
        self.init(domain: domain.rawValue, code: code.rawValue, userInfo: userInfo)
    }
}
