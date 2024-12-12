//
//  WeatherAPIHandler.swift
//  mixby2
//
//  Created by Anthony on 12/6/24.
//

import Foundation

func getWeatherFromAPI(updateWeatherName: @escaping (String) -> Void) {
    let locationManager = LocationManager.shared
    locationManager.onLocationUpdate = { latitude, longitude in
        let url = "http://cocktail.mixby.kro.kr:2222/weather/lat=\(latitude)/long=\(longitude)"
        let json = GetJsonFromURL(url: url)
        // print(json)

        var weather = json.split(separator: "weather")[1]
        weather = weather.split(separator: "]")[0]
        var id = weather.split(separator: "\"id\": ")[1]
        id = id.split(separator: ",")[0]

        DispatchQueue.main.async {
            let weatherName = getWeatherNameFromCode(weatherCode: String(id))
            // print(weatherName)
            updateWeatherName(weatherName) // 전달받은 클로저를 사용해 상태 업데이트
        }
    }
}

func getWeatherNameFromCode(weatherCode: String) -> String {
    let intCode: Int = Int(weatherCode) ?? 0
    // print("weatherCode: \(weatherCode)")
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
