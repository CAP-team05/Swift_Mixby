//
//  UserAPIHandler.swift
//  MixbyPreview
//
//  Created by Ys on 11/29/24.
//

import Foundation

class UserAPIHandler {
    public static let shared = UserAPIHandler()
    private let apiUrl: String = "http://cocktail.mixby.kro.kr:2222/persona"

    // API로 JSON 데이터를 전송
    func sendUserDataToAPI() {
        let users = UserHandler.shared.searchAll()
        let allNotes = TastingNoteHandler.shared.searchAll()
        let notes = allNotes.filter { $0.eval >= 0 }
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        do {
            // "ver" 태그와 "content" 태그를 추가한 JSON 데이터 생성
            let userPayload: [String: Any] = [
                "ver": "userInfo",
                "content": try JSONSerialization.jsonObject(with: jsonEncoder.encode(users)) as! [[String: Any]]
            ]
            
            let notePayload: [String: Any] = [
                "ver": "tastingNote",
                "content": try JSONSerialization.jsonObject(with: jsonEncoder.encode(notes)) as! [[String: Any]]
            ]
            // 두 JSON 데이터를 병합
            let combinedJSON: [[String: Any]] = [userPayload, notePayload]
            let jsonData = try JSONSerialization.data(withJSONObject: combinedJSON, options: .prettyPrinted)
            // print(jsonData)
            guard let url = URL(string: apiUrl) else {
                print("Invalid URL.")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending user data: \(error)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print("User data sent successfully.")
                    } else {
                        print("Failed to send user data. Status code: \(httpResponse.statusCode)")
                    }
                }
                
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        print("Response: \(responseString)")
                        do {
                            // Decode the response JSON to an array of dictionaries
                            let jsonDecoder = JSONDecoder()
                            let decodedData = try jsonDecoder.decode([String: String].self, from: data)

                            if let name = decodedData["name"],
                               let persona = decodedData["persona"] {
                                // Create UserDTO from the dictionary
                                let user = UserDTO(name: name, gender: "temp", favoriteTaste: "temp", persona: persona)
                                print("Decoded user: \(user), persona: \(user.persona)")
                                
                                // Update the database using updatePersona
                                UserHandler.shared.updatePersona(user: user)
                            } else if let result = decodedData["result"] {
                                print("Result received from API: \(result)")
                            }
                            print("Database successfully updated.")
                            
//                            for userDict in decodedData {
//                                if let name = userDict["name"],
//                                   let persona = userDict["persona"]{
//                                    // Create UserDTO from the dictionary
//                                    let user = UserDTO(name: name, gender: String("temp"), favoriteTaste: String("temp"), persona: persona)
//                                    print("in for decodeData user \(user) persona \(user.persona)")
//                                    // Update the database using updatePersona
//                                    self.userHandler.updatePersona(user: user)
//                                } else if let result = userDict["result"] {
//                                    print("Result received from API: \(result)")
//                                }
//                            }
//                            print("Database successfully updated.")
                        } catch {
                            print("Failed to decode JSON data: \(error)")
                        }
                    }
                } else {
                    print("error in response")
                }
            }
            task.resume()
        } catch {
            print("Failed to encode user data to JSON: \(error)")
        }
    }

//    // API에서 JSON 데이터를 받아서 SQLite에 저장
//    func fetchUserDataFromAPI() {
//        guard let url = URL(string: "http://127.0.0.1:2222/userinfo") else {
//            print("Invalid URL.")
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error fetching user data: \(error)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received from API.")
//                return
//            }
//
//            do {
//                let jsonDecoder = JSONDecoder()
//                let users = try jsonDecoder.decode([UserDTO].self, from: data)
//                print(users)
//
//                for user in users {
//                    self.userHandler.updatePersona(user: user)
//                }
//                print("User data fetched and stored successfully.")
//            } catch {
//                print("Failed to decode JSON data: \(error)")
//            }
//        }
//        task.resume()
//    }
//    
//    func updateUserDataFromAPI() {
//        guard let url = URL(string: "http://127.0.0.1:2222/userinfo") else {
//            print("Invalid URL.")
//            return
//        }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error fetching user data: \(error)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received from API.")
//                return
//            }
//
//            do {
//                // Decode the response JSON to an array of dictionaries
//                let jsonDecoder = JSONDecoder()
//                let decodedData = try jsonDecoder.decode([[String: String]].self, from: data)
//
//                for userDict in decodedData {
//                    if let name = userDict["name"],
//                       let persona = userDict["persona"],
//                       let gender = userDict["gender"],
//                       let favoriteTaste = userDict["favoriteTaste"] {
//                        // Create UserDTO from the dictionary
//                        let user = UserDTO(name: name, gender: gender, favoriteTaste: favoriteTaste, persona: persona)
//
//                        // Update the database using updatePersona
//                        self.userHandler.updatePersona(user: user)
//                    } else if let result = userDict["result"] {
//                        print("Result received from API: \(result)")
//                    }
//                }
//                print("Database successfully updated.")
//            } catch {
//                print("Failed to decode JSON data: \(error)")
//            }
//        }
//        task.resume()
//    }
}
