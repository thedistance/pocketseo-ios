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

class CachedOperation<CacheType:RequestCache>: Operation {
    
    var requestCache:CacheType
    var cacheKey:CacheType.RequestCacheKeyType
    var interval:NSTimeInterval
    
    init(cache:CacheType, key:CacheType.RequestCacheKeyType, interval:NSTimeInterval) {
        requestCache = cache
        cacheKey = key
        self.interval = interval
    }
    
    /// how to prevent execution...
    override func execute() {
        if requestCache.shouldIgnoreCacheForRequest(cacheKey, basedOnInterval: interval) {
            self.finish()
        }
    }
    
}



class MZAuthenticatedOperation: AlamofireJSONOperation {
    
    override init(method: Alamofire.Method, URLString: URLStringConvertible, parameters: [String : AnyObject]?, encoding: ParameterEncoding, headers: [String : String]?) {
        
        let token = MZAppDependencies.sharedDependencies().currentAuthenticationToken
        var authenticatedParameters = parameters ?? [String:AnyObject]()
        authenticatedParameters["AccessID"] = token.accessId
        authenticatedParameters["Expires"] = "\(token.expiry)"
        authenticatedParameters["Signature"] = token.signature

        super.init(method: method,
            URLString: URLString,
            parameters: authenticatedParameters,
            encoding: encoding,
            headers: headers)
    }
    
}