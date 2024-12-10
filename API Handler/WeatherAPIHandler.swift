//
//  WeatherAPIHandler.swift
//  mixby2
//
//  Created by Anthony on 12/6/24.
//

import Foundation

func getWeatherFromAPI() -> String {
    let locationManager = LocationManager()
    let lat = locationManager.latitude
    let long = locationManager.longitude
    
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
    case 200..<300: return "천둥"
    case 300..<400: return "이슬비"
    case 500..<600: return "비"
    case 600..<700: return "눈"
    case 800: return "맑음"
    case 801..<900: return "구름"
    default: return "미정의"
    }
}
