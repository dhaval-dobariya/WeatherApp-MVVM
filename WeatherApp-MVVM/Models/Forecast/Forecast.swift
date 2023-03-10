//
//  AIForecast.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 10/03/23.
//

import Foundation


// MARK: - Welcome
struct Forecast: Codable {
    let message: Int?
    let cod: String?
    let cnt: Int?
    let list: [List]?
    let city: City?
}

// MARK: - City
struct City: Codable {
    let sunset: Int?
    let country: String?
    let id: Int?
    let coord: Coord?
    let population, timezone, sunrise: Int?
    let name: String?
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Codable {
    let clouds: Clouds?
    let wind: Wind?
    let dt: Int?
    let rain: Rain?
    let dtTxt: String?
    let main: MainClass?
    let weather: [Weather]?
    let pop: Double?
    let sys: Sys?
    let visibility: Int?

    enum CodingKeys: String, CodingKey {
        case clouds, wind, dt, rain
        case dtTxt = "dt_txt"
        case main, weather, pop, sys, visibility
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - MainClass
struct MainClass: Codable {
    let humidity: Int?
    let feelsLike, tempMin, tempMax, temp: Double?
    let pressure: Int?
    let tempKf: Double?
    let seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp, pressure
        case tempKf = "temp_kf"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod?
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: MainEnum?
    let icon, description: String?
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
