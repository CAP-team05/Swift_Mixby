//
//  mixby2App.swift
//  mixby2
//
//  Created by Anthony on 11/26/24.
//

import SwiftUI

extension Array: @retroactive RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

func generateRecipeDTOsByGetKeywords(doPlus: Bool, keys: [String]) {
    RecipeHandler.dropTable()
    RecipeHandler.createTable()
    var keyword = getKeywordsByDrinkDTO(drinks: DrinkHandler.searchAll())
    if doPlus {
        for key in keys {
            keyword = keyword + key
        }
    }
    print("keyword: \(keyword)")
    let recipeDTOArray = getRecipeDTOListWithKeywords(key: keyword)
    for recipeDTO in recipeDTOArray {
        RecipeHandler.insert(recipe: recipeDTO)
    }
    print("recipeDTO generated completely")
}

func generateIngredientDTOsFromAPI() {
    IngredientHandler.dropTable()
    IngredientHandler.createTable()
    let ingredientDTOs = getAllIngredientsFromAPI()
    for ingredientDTO in ingredientDTOs {
        IngredientHandler.insert(ingredient: ingredientDTO)
    }
    print("ingredientDTO generated completely")
}

@main
struct mixby2App: App {
    @AppStorage("ownedIngs") var ownedIngs: [String] = []
    
    @State private var showSplash = true // 스플래시 상태
    
    @StateObject private var locationManager = LocationManager()
    @State private var weatherName: String = "Undefined"
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        performInitialization()
                    }
            } else {
                ContentView(ownedIngs: $ownedIngs, weatherName: weatherName)
            }
        }
    }
    
    func performInitialization() {
        DispatchQueue.global().async {
            // 초기화 작업 시뮬레이션
            sleep(2)
            DispatchQueue.main.async {
                if locationManager.latitude != 0.0 && locationManager.longitude != 0.0 {
                    print("lat, long: \(locationManager.latitude) \(locationManager.longitude)")
                    weatherName = getWeatherFromAPI(
                        lat: locationManager.latitude,
                        long: locationManager.longitude)
                }
                else {
                    print("can't get weatherName")
                }
                generateIngredientDTOsFromAPI()
                generateRecipeDTOsByGetKeywords(doPlus: true, keys: ownedIngs)
                withAnimation {
                    showSplash = false // 스플래시 상태 업데이트
                }
            }
        }
    }
}
