//
//  SearchResponse.swift
//  Reciplease
//
//  Created by damien on 20/07/2022.
//

import Foundation
import UIKit

// MARK: - SearchResponse
struct SearchResponse: Codable {
    let from, to, count: Int?
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
}


