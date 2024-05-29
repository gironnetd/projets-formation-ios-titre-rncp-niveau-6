//
//  FakeExchangeResponse.swift
//  Le BaluchonTests
//
//  Created by damien on 11/07/2022.
//

import Foundation

class FakeExchangeResponse {
    
    static var correctRates: Data? {
       let bundle = Bundle(for: FakeExchangeResponse.self)
       let url = bundle.url(forResource: "RatesResponse", withExtension: "json")!
       return try! Data(contentsOf: url)
    }
    
    static let incorrectRates = "erreur".data(using: .utf8)!
    
    static var correctSymbols: Data? {
       let bundle = Bundle(for: FakeExchangeResponse.self)
       let url = bundle.url(forResource: "SymbolsResponse", withExtension: "json")!
       return try! Data(contentsOf: url)
    }
    
    static let incorrectSymbols = "erreur".data(using: .utf8)!
}
