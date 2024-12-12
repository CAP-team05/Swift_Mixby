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
    RecipeHandler.shared.deleteAll()
    var keyword = getKeywordsByDrinkDTO(drinks: DrinkHandler.shared.searchAll())
    if doPlus {
        for key in keys {
            keyword = keyword + key
        }
    }
    print("keyword: \(keyword)")
    let recipeDTOArray = getRecipeDTOListWithKeywords(key: keyword)
    for recipeDTO in recipeDTOArray {
        RecipeHandler.shared.insert(recipe: recipeDTO)
    }
    print("recipeDTO generated completely")
}

func generateIngredientDTOsFromAPI() {
    IngredientHandler.shared.deleteAll()
    let ingredientDTOs = getAllIngredientsFromAPI()
    for ingredientDTO in ingredientDTOs {
        IngredientHandler.shared.insert(ingredient: ingredientDTO)
    }
    print("ingredientDTO generated completely")
}

@main
struct mixby2App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("ownedIngs") var ownedIngs: [String] = []
    
    @State private var showTutorial: Bool = true
    @State private var showSplash = true // 스플래시 상태
    
    @State private var weatherName: String = "null"
    
    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreenView()
                    .onAppear {
                        performInitialization()
                    }
            } else {
                ContentView(ownedIngs: $ownedIngs, weatherName: weatherName, showTutorial: showTutorial)
            }
        }
    }
    
    var audioPlayer: AudioPlayer? = AudioPlayer()
    
    func performInitialization() {
        audioPlayer?.playSound(fileName: "pouring", fileType: "mp3", volume: 0.2)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("알림 권한 허용됨")
            } else {
                print("알림 권한 거부됨: \(error?.localizedDescription ?? "알 수 없는 오류")")
            }
        }
        
        let serialQueue = DispatchQueue(label: "com.mixby.recommend.insertQueue")
        
        DispatchQueue.main.async {
            generateIngredientDTOsFromAPI()
            generateRecipeDTOsByGetKeywords(doPlus: true, keys: ownedIngs)
            
            // 초기화 작업 시작
            serialQueue.sync {
                let refreshTask = Task {
                    showTutorial = UserHandler.shared.searchAll().isEmpty
                    if !showTutorial {
                        UserAPIHandler.shared.sendUserDataToAPI()
                    }
                }
                let _ = getWeatherFromAPI { weather in
                    weatherName = weather
                }
                
                // 최소 6초 보장
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    Task {
                        await refreshTask.value // refreshTask가 끝나기를 기다림
                        withAnimation { showSplash = false }
                    }
                }
            }
        }
    }
}
