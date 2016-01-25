//
//  AlamofireJSONOperation.swift
//  AdvancedOperationKit
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 Josh Campion. All rights reserved.
//

import Foundation
import PSOperations
import Alamofire
import SwiftyJSON

typealias SwiftyJSONResponseCompletion = (jsonResponse:Response<JSON, NSError>) -> Void

extension Request {
    
    public static func swiftyJSONResponseSerializer(
        options options: NSJSONReadingOptions = .AllowFragments)
        -> ResponseSerializer<JSON, NSError>
    {
        return ResponseSerializer { _, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            if let response = response where response.statusCode == 204 { return .Success(JSON(NSNull())) }
            
            guard let validData = data where validData.length > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            var jsonError:NSError?
            let json = JSON(data: validData, options: options, error: &jsonError)
            
            if let error = jsonError {
                return .Failure(error)
            } else {
                return .Success(json)
            }
        }
    }
    
    public func responseSwiftyJSON(
        options options: NSJSONReadingOptions = .AllowFragments,
        completionHandler: Response<JSON, NSError> -> Void)
        -> Self
    {
        return response(
            responseSerializer: Request.swiftyJSONResponseSerializer(options: options),
            completionHandler: completionHandler
        )
    }
}

/**
 
 Base `Operation` subclass for all network requests. This wraps Alamofire networking requests into the `Operation` paradigm. It can be created with either an `NSURLRequest` or the parameters for an Alamofire request. Subclasses are expected to add a `success` block with a struct parameter ensuring the networking logic and JSON parsing / structure remains contained entirely within a single operation.
 
 For simplicity the designated initialiser is `init(method:URLString:parameters:encoding:headers:sendAsJSON:)`. If direct customisation of the request is required, use the init(request:) method.
 
 Subclasses are expected to set the `responseSuccess` block which will convert the JSON returned from the requst into Viper Entities or handle it appropriately. The block should then call `finish(errors:)` block or a `success` block of their own definition containing the struct parameters. `finish()` should **not** called from the `responseSuccess` block. This is called automatically.
 
 The `failure(error:)` block is called automatically from `finished(errors:)` and should not be called directly. This allows the `failure` block to be called from an operation that is cancelled by a failing `OperationCondition`.
 */
class AlamofireJSONOperation: Operation {
    
    /// Optional property set via the init(request:) method allowing further customisation of the network request over the designated initialiser.
    var request:NSURLRequest?
    
    /// Passed to Alamofire request.
    let method:Alamofire.Method
    
    /// Passed to Alamofire request.
    var urlString: URLStringConvertible
    
    /// Passed to Alamofire request.
    var parameters:[String:AnyObject]?
    
    /// Passed to Alamofire request.
    let encoding: ParameterEncoding
    
    /// Passed to Alamofire request.
    var headers: [String:String]?
    
    /// Called on completion of the Alamofire request. If set the `responseSuccess` block is not called. Users setting this variable should ensure `finish(_:)` is called appropriately from this block. This will **not** be called on the main thread. It is the caller's responsibility to dispatch back to the main queue if appropriate.
    var completion: SwiftyJSONResponseCompletion?
    
    /// Optional block to run if the Alamofire request's response returns a `Result.Failure`. A call to `self.finish(_:)` calls this method from `finished(_:)` if the `errors` parameter is empty. As such this should not be called directly. This will **not** be called on the main thread. It is the caller's responsibility to dispatch back to the main queue if appropriate.
    var failure:((errors:[NSError]) -> ())?
    
    /// Used internally to store the block set by a subclass.
    private var _responseSuccess:((json:JSON) -> ())?
    
    /// Optional block to run if the Alamofire request's response returns a `Result.Success`. A call to `self.finish(_:)` is appended to this block. If the `completion` variable is set, this is not called.
    var responseSuccess:((json:JSON) -> ()) {
        get {
            let complete = { (json:JSON) in
                self._responseSuccess?(json:json)
                self.finish()
            }
            
            return complete
        }
        set {
            _responseSuccess = newValue
        }
    }
    
    /// Designated Initialiser. Paramters are passed to the Alamofire `request` method on `execute()`.
    init(method:Alamofire.Method, URLString:URLStringConvertible, parameters:[String:AnyObject]? = nil, encoding: ParameterEncoding = .JSON, headers: [String:String]? = nil) {
        
        var headersToSend = headers ?? [String:String]()
        headersToSend["Accept"] = "application/json"
        
        self.method = method
        self.urlString = URLString
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headersToSend
        
        self.request = nil
        
        super.init()
    }
    
    /// Initialiser for creating an Alamofire request with an explicit NSURLRequest, allowing more customisation of the request e.g. setting the HTTPBody if the default `[String:AnyObject]?` paramter is not appropriate.
    init(request: NSURLRequest) {
        
        self.method = Method(rawValue:request.HTTPMethod!)!
        self.encoding = .JSON
        self.urlString = request.URLString
        
        self.request = request
        
        super.init()
    }
    
    override func execute() {
        
        // the default completion to execute regardless of the request being from an NSURLRequest or parameters
        let defaultCompletion:SwiftyJSONResponseCompletion = { [unowned self] (response) -> Void in
            
            switch response.result {
            case .Success(let json):
                self.responseSuccess(json: json)
            case .Failure(let error):
                self.finish([error])
            }
        }
        
        // execute the default iff the completion block has not been set externally
        let requestCompletion:SwiftyJSONResponseCompletion
        if let completion = self.completion {
            requestCompletion = completion
        } else {
            requestCompletion = defaultCompletion
        }
        
        // perform the request
        if let request = self.request {
            
            Alamofire.request(request)
                .validate()
                .responseSwiftyJSON(completionHandler: requestCompletion)
            
        } else {
            Alamofire.request(method, urlString, parameters: parameters, encoding: encoding, headers: headers)
                .validate()
                .responseSwiftyJSON(completionHandler: requestCompletion)
        }
    }
    
    override func finished(errors: [NSError]) {
        if errors.count > 0 {
            failure?(errors:errors)
        }
    }
}
