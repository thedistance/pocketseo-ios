//
//  NLAssertEqualOptional.swift
//  NLAssertEqualOptionalExample
//
//  Created by Nikola Lajic on 10/3/14.
//  Copyright (c) 2014 codecentric. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
    func NLAssertEqualOptional<T : Equatable>(@autoclosure expression1: () -> T?, @autoclosure _ expression2: () -> T?, _ message: String? = nil, file: String = __FILE__, line: UInt = __LINE__) {
        
        var m = "NLAssertEqualOptional failed - "
        
        let e1 = expression1()
        let e2 = expression2()
        
        switch (e1, e2) {
        case (.Some, .None), (.None, .Some):
            self.recordFailureWithDescription(m + "\(e1) != \(e2): Only one optional value is empty. " + (message ?? ""), inFile: file, atLine: line, expected: true)
        case (.None, .None):
            // nothing to do, nil == nil
            let _ = true
        case (.Some, .Some):
            
            let v1 = e1!
            let v2 = e2!
            if v1 != v2 {
                if let message = message {
                    m += message
                }
                else {
                    m += "Optional (\(v1)) is not equal to (\(v2))"
                }
                self.recordFailureWithDescription(m, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func NLAssertEqualOptional<T : Equatable>(@autoclosure expression1: () -> [T]?, @autoclosure _ expression2: () -> [T]?, _ message: String? = nil, file: String = __FILE__, line: UInt = __LINE__) {
        
        var m = "NLAssertEqualOptional failed - "
        
        let e1 = expression1()
        let e2 = expression2()
        
        switch (e1, e2) {
        case (.Some, .None), (.None, .Some):
            self.recordFailureWithDescription(m + "\(e1) != \(e2): Only one optional value is empty. " + (message ?? ""), inFile: file, atLine: line, expected: true)
        case (.None, .None):
            // nothing to do, nil == nil
            let _ = true
        case (.Some, .Some):
            
            let v1 = e1!
            let v2 = e2!
            if v1 != v2 {
                if let message = message {
                    m += message
                }
                else {
                    m += "Optional (\(v1)) is not equal to (\(v2))"
                }
                self.recordFailureWithDescription(m, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func NLAssertEqualOptional<T, U : Equatable>(@autoclosure expression1: () -> [T : U]?, @autoclosure _ expression2: () -> [T : U]?, _ message: String? = nil, file: String = __FILE__, line: UInt = __LINE__) {
        
        var m = "NLAssertEqualOptional failed - "
        
        let e1 = expression1()
        let e2 = expression2()
        
        switch (e1, e2) {
        case (.Some, .None), (.None, .Some):
            self.recordFailureWithDescription(m + "\(e1) != \(e2): Only one optional value is empty. " + (message ?? ""), inFile: file, atLine: line, expected: true)
        case (.None, .None):
            // nothing to do, nil == nil
            let _ = true
        case (.Some, .Some):
            
            let v1 = e1!
            let v2 = e2!
            if v1 != v2 {
                if let message = message {
                    m += message
                }
                else {
                    m += "Optional (\(v1)) is not equal to (\(v2))"
                }
                self.recordFailureWithDescription(m, inFile: file, atLine: line, expected: true)
            }
        }
    }
}
