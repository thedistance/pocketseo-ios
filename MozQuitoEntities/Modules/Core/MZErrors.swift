//
//  MZErrors.swift
//  MozQuito
//
//  Created by Josh Campion on 27/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

public enum MZErrorDomain:String {
    case InitError
    case MozscapeError
    case HTMLError
    case XMLError
    case UserInputError
}

public enum MZErrorCode:Int {
    case UnexpectedResponse
    case InvalidURL
}

public extension NSError {
    
    public convenience init(InitUnexpectedResponseWithDescription descr: String) {
        self.init(domain: .InitError, code:.UnexpectedResponse, userInfo: [NSLocalizedDescriptionKey: descr])
    }
    
    public convenience init(domain:MZErrorDomain, code:MZErrorCode, userInfo:[NSObject:AnyObject]?) {
        self.init(domain: domain.rawValue, code: code.rawValue, userInfo: userInfo)
    }
}
