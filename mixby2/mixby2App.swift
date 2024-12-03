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
    @State private var showSplash = true // 스플래시 상태

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        performInitialization()
                    }
            } else {
                ContentView() // 로딩 완료 후 표시
            }
        }
    }

    func performInitialization() {
        DispatchQueue.global().async {
            // 초기화 작업 시뮬레이션
            sleep(2)
            DispatchQueue.main.async {
                withAnimation {
                    showSplash = false // 스플래시 상태 업데이트
                }
            }
        }
    }
}
