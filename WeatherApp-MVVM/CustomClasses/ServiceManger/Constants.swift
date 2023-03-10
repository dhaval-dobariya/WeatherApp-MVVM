//
//  Constants.swift
//  WeatherApp-MVVM
//
//  Created by Dhaval Dobariya on 09/03/23.
//

import Foundation

let URL_FORCAST             = "forecast"
let URL_ADD_BUSINESS        = "add_business_video"
let IS_DEVELOPER_MODE = false
let BASE_URL = "http://api.openweathermap.org/"
let SEARVER_PATH = "data/2.5/"

func getUrl(_ api:String) -> String {
    return BASE_URL + SEARVER_PATH + api
}

// Third party access key
struct CredentialKey {
    static let OpenWeatherMap    = "5ddeaf35995293079e7bce5db6a56a8d"
}
