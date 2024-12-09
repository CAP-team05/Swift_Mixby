//
//  RecommendAPIHandler.swift
//  mixby2
//
//  Created by Ys on 12/3/24.
//

import Foundation
import SwiftUI

let m2s: [String] = ["null", "겨울", "겨울", "봄", "봄", "봄", "여름", "여름", "여름", "가을", "가을", "가을", "겨울", "겨울"]

func testCode() {
    UserHandler.createTable()
    UserHandler.insert(user: UserDTO(name: "재현", gender: "남성", favoriteTaste: "단맛", persona: "테스트유저는 남성이며 달콤한 맛을 선호합니다. 단맛을 중시하는 취향을 가진 칵테일 애호가입니다."))
    RecipeHandler.createTable()
    RecipeHandler.insert(recipe: RecipeDTO(code: "700211031", english_name: "Alexander", korean_name: "알렉산더", tag1: "부드러움", tag2: "우유향", have: "5-5"))
    RecipeHandler.insert(recipe: RecipeDTO(code: "204205206018019", english_name: "Jun-Bug", korean_name: "준 벅", tag1: "트로피칼", tag2: "과일향", have: "5-5"))
    RecipeHandler.insert(recipe: RecipeDTO(code: "1", english_name: "Alexander", korean_name: "아메리카노", tag1: "", tag2: "우유향", have: "5-5"))
    RecipeHandler.insert(recipe: RecipeDTO(code: "2", english_name: "Alexander", korean_name: "피나 콜라다", tag1: "", tag2: "우유향", have: "5-5"))
    RecipeHandler.insert(recipe: RecipeDTO(code: "3", english_name: "Alexander", korean_name: "테킬라 선라이즈", tag1: "", tag2: "우유향", have: "5-5"))
}

// API로 JSON 데이터를 전송
func getRecommend(completion: @escaping (String) -> Void) {
    let userPersona = UserHandler.searchAll().last?.persona
    let haveRecipes = RecipeHandler.searchHave()
    let time = TimeHandler.getCurrentHour()
    let weather = getWeatherFromAPI()
    
    let jsonEncoder = JSONEncoder()
    let apiUrl: String = "http://cocktail.mixby.kro.kr:2222/recommend"
    jsonEncoder.outputFormatting = .prettyPrinted
    
    var strHaveRecipe = ""
    for recipe in haveRecipes {
        strHaveRecipe += "\(recipe.korean_name), "
    }
    
    do {
        let personaData = try jsonEncoder.encode(userPersona)
        let recipesData = try jsonEncoder.encode(strHaveRecipe)
        let seasonData = try jsonEncoder.encode(m2s[TimeHandler.getCurrentMonth()])
        let timeData = try jsonEncoder.encode(time)
        let weatherData = try jsonEncoder.encode(weather)
        
        let jsonDictionary: [String: Any] = [
            "persona": String(data: personaData, encoding: .utf8) ?? "",
            "cocktail_list": String(data: recipesData, encoding: .utf8) ?? "",
            "season": String(data: seasonData, encoding: .utf8) ?? "",
            "time": String(data: timeData, encoding: .utf8) ?? "",
            "weather": String(data: weatherData, encoding: .utf8) ?? ""
        ]
        guard let url = URL(string: apiUrl) else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending user data: \(error)")
                completion("Error sending user data: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Failed to send user data. Status code: \(httpResponse.statusCode)")
                completion("Failed to send user data. Status code: \(httpResponse.statusCode)")
                return
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(responseString)
            } else {
                print("error in response")
                completion("Error processing the response")
            }
        }
        task.resume()
    } catch {
        print("Failed to encode user data to JSON: \(error)")
        completion("Failed to encode data")
    }
}

func refreshDefaultRecommendDTOs(completion: @escaping () -> Void) {
    print("getting recommends until get 3")
    
    DispatchQueue.global().async {
        RecommendHandler.dropTable()
        RecommendHandler.createTable()
        
        let _ = getRecommend() { json in
            let cleanedJson = json
                .replacingOccurrences(of: "\\\"", with: "\"")
                .replacingOccurrences(of: "\\n", with: "\n")
                .replacingOccurrences(of: "\\", with: "")
                .replacingOccurrences(of: "  ", with: "")
                .trimmingCharacters(in: CharacterSet(charactersIn: "\""))
            
            let arr = cleanedJson.split(separator: "},")
            print(arr.count, cleanedJson)
            
            for a in arr {
                let eng_name = getTagFromJson(json: String(a), tag: "name")
                let tag = getTagFromJson(json: String(a), tag: "tag")
                let reason = getTagFromJson(json: String(a), tag: "reason")
                
                let recommendDTO = RecommendDTO(name: eng_name, reason: reason, tag: tag)
                
                RecommendHandler.insert(recommend: recommendDTO)
            }
            
            let cnt = RecommendHandler.searchAll().count
            print("recommendDTO inserted: \(cnt)")
            
            if cnt < 3 {
                print("Count is less than 3. Retrying...")
            } else {
                print("Count is 3 or more. Ending...")
            }
            DispatchQueue.main.async {
                completion() // 완료 후 호출
            }
        }
    }
}
