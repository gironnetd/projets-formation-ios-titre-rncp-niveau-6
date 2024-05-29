//
//  ExchangeResponse.swift
//  Le Baluchon
//
//  Created by damien on 27/06/2022.
//

import Foundation

//
// MARK: - Exchange Response
//
struct ExchangeResponse: Codable {
    let success: Bool
    let timestamp: Int?
    let base, date: String?
    let symbols: [String: String]?
    let rates: [String: Double]?
}
