//
//  TranslationResponse.swift
//  Le Baluchon
//
//  Created by damien on 23/06/2022.
//

import Foundation

//
// MARK: - Translation Response
//
struct TranslationResponse: Codable {
    let data: Data?
}

// MARK: - Data
struct Data: Codable {
    let translations: [Translation]?
    let detections: [[Detection]]?
    let languages: [Language]?
}

// MARK: - Translation
struct Translation: Codable {
    let translatedText: String
}

// MARK: - Detection
struct Detection: Codable {
    let confidence: Int
    let isReliable: Bool
    let language: String
}

// MARK: - Language
struct Language: Codable {
    let language: String
}

