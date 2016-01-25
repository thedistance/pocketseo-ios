//
//  MZAuthenticatedOperation.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

import PSOperations
import Alamofire
import TheDistanceCore

class MZAuthenticatedOperation: AlamofireJSONOperation {
    
    override init(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String : AnyObject]?, encoding: ParameterEncoding, headers: [String : String]?) {
        
        let token = MZAppDependencies.sharedDependencies().currentAuthenticationToken
        var authenticatedParameters = parameters ?? [String:AnyObject]()
        authenticatedParameters["AccessID"] = token.accessId
        authenticatedParameters["Expires"] = token.expiry
        authenticatedParameters["Signature"] = token.signature

        super.init(method: method,
            URLString: URLString,
            parameters: authenticatedParameters,
            encoding: encoding,
            headers: headers)
    }
    
}