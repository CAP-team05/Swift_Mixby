//
//  RecommendAPIHandler.swift
//  mixby2
//
//  Created by Ys on 12/3/24.
//

import Foundation

class RecommendAPIHandler {
    private let apiUrl: String = "http://cocktail.mixby.kro.kr:2222/recommend"

    // API로 JSON 데이터를 전송
//    func getRecommand() {
//        let users = UserHandler.searchAll()
//        let haveRecipes = RecipeHandler.searchHave()
//        let jsonEncoder = JSONEncoder()
//        jsonEncoder.outputFormatting = .prettyPrinted
//        
//        do {
//            // "ver" 태그와 "content" 태그를 추가한 JSON 데이터 생성
//            let userPayload: [String: Any] = [
//                "ver": "userInfo",
//                "content": try JSONSerialization.jsonObject(with: jsonEncoder.encode(users)) as! [[String: Any]]
//            ]
//            
//            let notePayload: [String: Any] = [
//                "ver": "tastingNote",
//                "content": try JSONSerialization.jsonObject(with: jsonEncoder.encode(notes)) as! [[String: Any]]
//            ]
//            // 두 JSON 데이터를 병합
//            let combinedJSON: [[String: Any]] = [userPayload, notePayload]
//            let jsonData = try JSONSerialization.data(withJSONObject: combinedJSON, options: .prettyPrinted)
//            // print(jsonData)
//            guard let url = URL(string: apiUrl) else {
//                print("Invalid URL.")
//                return
//            }
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//            
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Error sending user data: \(error)")
//                    return
//                }
//                
//                if let httpResponse = response as? HTTPURLResponse {
//                    if httpResponse.statusCode == 200 {
//                        print("User data sent successfully.")
//                    } else {
//                        print("Failed to send user data. Status code: \(httpResponse.statusCode)")
//                    }
//                }
//                
//                if let data = data, let responseString = String(data: data, encoding: .utf8) {
//                    DispatchQueue.main.async {
//                        print("Response: \(responseString)")
//                        do {
//                            // Decode the response JSON to an array of dictionaries
//                            let jsonDecoder = JSONDecoder()
//                            let decodedData = try jsonDecoder.decode([String: String].self, from: data)
//                            
//                            if let name = decodedData["name"],
//                               let persona = decodedData["persona"] {
//                                // Create UserDTO from the dictionary
//                                let user = UserDTO(name: name, gender: "temp", favoriteTaste: "temp", persona: persona)
//                                print("Decoded user: \(user), persona: \(user.persona)")
//                                
//                                // Update the database using updatePersona
//                                self.userHandler.updatePersona(user: user)
//                            } else if let result = decodedData["result"] {
//                                print("Result received from API: \(result)")
//                            }
//                            print("Database successfully updated.")
//                        } catch {
//                            print("Failed to decode JSON data: \(error)")
//                        }
//                    }
//                } else {
//                    print("error in response")
//                }
//            }
//            task.resume()
//        } catch {
//            print("Failed to encode user data to JSON: \(error)")
//        }
//    }
}
