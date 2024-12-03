//
//  RecipeDTO.swift
//  mixby2
//
//  Created by Anthony on 12/1/24.
//

import Foundation

public struct RecipeDTO: Codable {
    var code: String
    var english_name: String
    var korean_name: String
    var tag1: String
    var tag2: String
    var have: String
    
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(self) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}
