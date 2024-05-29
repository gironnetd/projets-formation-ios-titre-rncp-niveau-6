//
//  Publisher+Extension.swift
//  util
//
//  Created by damien on 19/09/2022.
//

import Foundation
import Combine
import XCTest

///
/// Extension of the Publisher Protocol
///
extension Publisher {
    
    /// Function allowing to wait for the end of a completion
    ///
    /// - Returns: An Array of Output
    public func waitingCompletion(for timeout: TimeInterval = 30.0, file: StaticString = #file, line: UInt = #line) throws -> [Output] {
        let expectation = XCTestExpectation(description: "Wait for completion")
        var completion: Subscribers.Completion<Failure>?
        var output = [Output]()

        let subscription = self.collect()
            .sink(receiveCompletion: { receiveCompletion in
                completion = receiveCompletion
                expectation.fulfill()
            }, receiveValue: { value in
                output = value
            })

        XCTWaiter().wait(for: [expectation], timeout: timeout)
        subscription.cancel()

        // We're also including a more meaningful error here!
        switch try XCTUnwrap(completion, "Publisher never completed", file: file, line: line) {
        case let .failure(error):
            throw error
        case .finished:
            return output
        }
    }
}
