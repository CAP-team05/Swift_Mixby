//
//  DrinkDTO.swift
//  MixbyPreview
//
//  Created by Ys on 11/30/24.
//

import Foundation

public struct DrinkDTO: Codable {
    var code: String
    var name: String
    var baseCode: String
    var type: String
    var volume: String
    var alcohol: String
    var description: String
    
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(self) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}
