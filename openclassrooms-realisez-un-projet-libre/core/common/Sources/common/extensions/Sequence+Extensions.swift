//
//  Sequence+Extension.swift
//  common
//
//  Created by Damien Gironnet on 16/04/2023.
//

import Foundation

///
/// Extension for Sequence Protocol
///
public extension Sequence {
    
    /// Function allowing to use map function with structured concurrency
    ///
    /// - Returns: An Array of the Generic Type
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
    
    func asyncReduce<Result>(
        _ initialResult: Result,
        _ nextPartialResult: ((Result, Element) async throws -> Result)
    ) async rethrows -> Result {
        var result = initialResult
        for element in self {
            result = try await nextPartialResult(result, element)
        }
        return result
    }
}
