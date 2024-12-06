//
//  WeatherAPIHandler.swift
//  mixby2
//
//  Created by Anthony on 12/6/24.
//

import Foundation

func getWeatherFromAPI(lat: Double, long: Double) -> String {
    let json = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/weather/lat=\(lat)/long=\(long)")
    
    var weather = json.split(separator: "weather")[1]
    weather = weather.split(separator: "]")[0]
    var id = weather.split(separator: "\"id\": ")[1]
    id = id.split(separator: ",")[0]
    return getWeatherNameFromCode(weatherCode: String(id))
}

func getWeatherNameFromCode(weatherCode: String) -> String {
    let intCode: Int = Int(weatherCode) ?? 0
    print("weatherCode: \(weatherCode)")
    switch intCode {
    case 200..<300: return "Thunderstorm"
    case 300..<400: return "Drizzle"
    case 500..<600: return "Rain"
    case 600..<700: return "Snow"
    case 800: return "Moon"
        // if formattedDate >= 6 && formattedDate <= 19 { return "Clear" }
    case 801..<900: return "Clouds"
    default: return "Undefined"
    }
}
