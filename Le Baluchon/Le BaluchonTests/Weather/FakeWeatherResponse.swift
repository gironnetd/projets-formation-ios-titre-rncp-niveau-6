//
//  FakeWeatherResponse.swift
//  Le BaluchonTests
//
//  Created by damien on 13/07/2022.
//

import Foundation

class FakeWeatherResponse {
    
    static var correctWeather: Data? {
       let bundle = Bundle(for: FakeWeatherResponse.self)
       let url = bundle.url(forResource: "WeatherResponse", withExtension: "json")!
       return try! Data(contentsOf: url)
    }
    
    static let incorrectWeather = "erreur".data(using: .utf8)!
    
    static let correctIcon = "image".data(using: .utf8)!
}
