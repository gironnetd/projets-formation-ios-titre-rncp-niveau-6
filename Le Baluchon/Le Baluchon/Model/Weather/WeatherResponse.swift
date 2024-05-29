//
//  WeatherResponse.swift
//  Le Baluchon
//
//  Created by damien on 11/07/2022.
//

import Foundation

//
// MARK: - Weather Response
//
struct WeatherResponse: Codable, Equatable {
    static func == (lhs: WeatherResponse, rhs: WeatherResponse) -> Bool {
        return lhs.coord == rhs.coord &&
            lhs.weather == rhs.weather &&
        lhs.base == rhs.base &&
        lhs.main == rhs.main &&
        lhs.visibility == rhs.visibility &&
        lhs.wind == rhs.wind &&
        lhs.clouds == rhs.clouds &&
        lhs.dt == rhs.dt &&
        lhs.sys == rhs.sys &&
        lhs.timezone == rhs.timezone &&
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.cod == rhs.cod 
    }
    
    let coord: Coord
    var weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable, Equatable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable, Equatable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable, Equatable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable, Equatable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable, Equatable {
    let id: Int
    let main, weatherDescription, icon: String
    var iconImage: Foundation.Data?
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
        case iconImage
    }
}

// MARK: - Wind
struct Wind: Codable, Equatable {
    let speed: Double
    let deg: Int
}
