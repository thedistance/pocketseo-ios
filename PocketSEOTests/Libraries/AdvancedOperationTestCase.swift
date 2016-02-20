//
//  AdvancedOperationTestCase.swift
//
//  Copyright (c) 2015, Joshua Robert Campion
//
//  Definitions:
//
//  "Author" shall refer to Joshua Robert Campion.
//  "Software" shall refer to all code and documentation within the repository 'AdvancedOperationKit' as defined by the s.source entry in AdvancedOperationKit.podspec.
//
//  License:
//
//  Permission is hereby granted, free of charge, for use of the Software in, and only in, the app with Apple Bundle Ids:
//
//  * io.interchange.Interchange
//  * io.interchange.InterchangeTests
//  * io.interchange.InterchangeUITests
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  All rights remain with the Author. Use in other projects and/or any of copying, modifying, merging, publishing, distributing, sublicensing, selling of the Software is not permitted.
//
//  Use of this Software is acceptance of the terms in this License.
//
//

import XCTest
import AdvancedOperationKit
import PSOperations

typealias OperationCompletionClosure = (operation: NSOperation, errors:[NSError]) -> ()

class AdvancedOperationTestCase: XCTestCase, OperationQueueDelegate {
    
    var operationExpectations = [String:XCTestExpectation]()
    
    var operationCompletions = [String:OperationCompletionClosure]()
    
    var anyOperationCompletion: OperationCompletionClosure?
    
    override func setUp() {
        super.setUp()
        
        operationExpectations.removeAll()
        operationCompletions.removeAll()
        anyOperationCompletion = nil
    }
    
    lazy var operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.delegate = self
        
        return queue
        }()
    
    func registerAndRunOperation(operation:NSOperation, named:String, timeout: NSTimeInterval = 10.0, handler: XCWaitCompletionHandler? = nil, completion:OperationCompletionClosure) {
        let expectation = expectationWithDescription(named)
        operation.name = named
        
        registerOperation(operation, withExpectation: expectation, completion: completion)
        
        operationQueue.addOperation(operation)
        
        waitForExpectationsWithTimeout(timeout, handler: handler)
    }
    
    func registerOperation(operation:NSOperation, withExpectation expectation:XCTestExpectation, completion:OperationCompletionClosure) {
        
        if let key = operation.name {
            operationExpectations[key] = expectation
            operationCompletions[key] = completion
        } else {
            assertionFailure("Cannot register an operation with no name.")
        }
    }
    
    func operationQueue(operationQueue: OperationQueue, operationDidFinish operation: NSOperation, withErrors errors: [NSError]) {
        
        print("operation finished: \(operation)")
        
        if let key = operation.name,
            let expectation = operationExpectations[key],
            let completion = operationCompletions[key] {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    expectation.fulfill()
                    completion(operation: operation, errors: errors)
                })
                
                operationCompletions[key] = nil
                operationExpectations[key] = nil
        } else if let completion = anyOperationCompletion {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completion(operation: operation, errors: errors)
            })
        }
    }
    
}


