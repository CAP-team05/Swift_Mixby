//
//  TastingNoteDTO.swift
//  MixbyPreview
//
//  Created by Ys on 11/29/24.
//

import Foundation

public struct IngredientDTO: Codable {
    var name: String = ""
    var code: String = ""
    
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(self) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

