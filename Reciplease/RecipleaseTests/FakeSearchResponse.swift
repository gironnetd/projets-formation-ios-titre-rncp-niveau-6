//
//  FakeSearchResponse.swift
//  RecipleaseTests
//
//  Created by damien on 27/07/2022.
//

import Foundation

class FakeSearchResponse {
    
    static var search: Data {
       let bundle = Bundle(for: FakeSearchResponse.self)
       let url = bundle.url(forResource: "SearchResponse", withExtension: "json")!
       return try! Data(contentsOf: url)
    }
}
