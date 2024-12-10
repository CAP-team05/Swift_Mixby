//
//  DrinkDTO.swift
//  MixbyPreview
//
//  Created by Ys on 11/30/24.
//

import Foundation

public struct RecommendDTO: Codable {
    var name: String
    var reason: String
    var tag: String
    
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(self) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}
