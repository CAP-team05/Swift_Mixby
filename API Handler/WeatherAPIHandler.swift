//
//  WeatherAPIHandler.swift
//  mixby2
//
//  Created by Anthony on 12/6/24.
//

func getWeather(lat: Double, long: Double) -> String {
    let json = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/weather/lat=\(lat)/long=\(long)")
    
    var weather = json.split(separator: "weather")[1]
    weather = weather.split(separator: "]")[0]
    var id = weather.split(separator: "\"id\": ")[1]
    id = id.split(separator: ",")[0]
    return String(id)
}
