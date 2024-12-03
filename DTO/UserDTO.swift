//
//  UserDTO.swift
//  MixbyPreview
//
//  Created by Ys on 11/29/24.
//

import Foundation

public struct UserDTO: Codable {
    var name: String
    var gender: String
    var favoriteTaste: String
    var persona: String
    
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(self) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}
