//
//  AsyncStreamTests.swift
//  KitUI
//
//  Created by Chris Brakebill on 9/23/22.
//

import XCTest
@testable import KitUI

final class AsyncStreamTests: XCTestCase {
    
    func testAsyncStream() throws {
        var continuation: AsyncStream<Int>.Continuation!
        let stream = AsyncStream<Int>.init { a in
            continuation = a
        }
        
        let expectation = self.expectation(description: "Expect the producer to complete")
        let producer = stream.producer.collect().startWithValues { value in
            XCTAssertEqual([1,2,3], value)
            expectation.fulfill()
        }
        
        continuation.yield(1)
        continuation.yield(2)
        continuation.yield(3)
        continuation.finish()
        self.waitForExpectations(timeout: 5)
    }
    
    func testAsyncThrowingStream() throws {
        var continuation: AsyncThrowingStream<Int, Error>.Continuation!
        let stream = AsyncThrowingStream<Int, Error> { a in
            continuation = a
        }
        
        let expectation = self.expectation(description: "Expect the producer to complete")
        let producer = stream.producer.startWithResult { result in
            switch result {
            case .failure:
                expectation.fulfill()
            case .success:
                return
            }
        }
        continuation.finish(throwing: NSError(domain: "", code: -1))
        self.waitForExpectations(timeout: 5)
    }
}
