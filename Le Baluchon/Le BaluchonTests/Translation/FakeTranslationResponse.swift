//
//  FakeTranslationResponse.swift
//  Le BaluchonTests
//
//  Created by damien on 16/07/2022.
//

import Foundation

class FakeTranslationResponse {
    
    static var translation: Data? {
       let bundle = Bundle(for: FakeTranslationResponse.self)
       let url = bundle.url(forResource: "TranslationResponse", withExtension: "json")!
       return try! Data(contentsOf: url)
    }
    
    static var detection: Data? {
       let bundle = Bundle(for: FakeTranslationResponse.self)
       let url = bundle.url(forResource: "DetectionResponse", withExtension: "json")!
       return try! Data(contentsOf: url)
    }
    
    static var languages: Data? {
       let bundle = Bundle(for: FakeTranslationResponse.self)
       let url = bundle.url(forResource: "LanguagesResponse", withExtension: "json")!
       return try! Data(contentsOf: url)
    }
    
    static let incorrectTranslation = "erreur".data(using: .utf8)!
}
