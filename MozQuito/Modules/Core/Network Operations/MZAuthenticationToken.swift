//
//  MZAuthentication.swift
//  MozQuito
//
//  Created by Josh Campion on 25/01/2016.
//  Copyright © 2016 The Distance. All rights reserved.
//

import Foundation

enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    func toCCEnum() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func digestUsingAlgorithm(algorithm: HMACAlgorithm, key: String) -> String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = Int(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = algorithm.digestLength()
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)
        let keyLen = Int(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        CCHmac(algorithm.toCCEnum(), keyStr!, keyLen, str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.destroy()
        
        return String(hash)
    }
    
}

/// The time into the future when an MZAuthenticationToken expires.
let MZAuthenticationExpiryInterval:NSTimeInterval = 300.0

struct MZAuthenicationToken {
    
    /// The access ID for the Mozscape API
    let accessId = "mozscape-9ccf391475"
    
    /// The access scret for accessing the Mozcape API
    let secret = "95cd3ffd5e155946b876758052cdf395"
    
    /// The unix time that this authentication token expires in, created on `init()`.
    let expiry:NSTimeInterval
    
    /// `NSDate` representation of the `expry` property.
    var expiryDate:NSDate {
        return NSDate(timeIntervalSince1970: expiry)
    }
    
    /// The encoded string that can be used to authenticate requests Mozscape API requests with.
    let signature:String
    
    init() {
        expiry = NSDate().timeIntervalSince1970 + MZAuthenticationExpiryInterval
        
        let toEncode = "\(accessId)\n\(expiry)"
        
        let toEncodeData = toEncode.dataUsingEncoding(NSUTF8StringEncoding)!
        let toEncodeLength = toEncodeData.length
        let signatureData:NSMutableData? = NSMutableData(length: Int(CC_SHA1_DIGEST_LENGTH))
        let secretData = secret.dataUsingEncoding(NSUTF8StringEncoding)!
        let secretLength = secretData.length
        
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), secretData.bytes, secretLength, toEncodeData.bytes, toEncodeLength, signatureData!.mutableBytes)
        
        signature = signatureData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength) ?? ""
    }
}


