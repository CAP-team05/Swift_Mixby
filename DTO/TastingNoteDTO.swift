//
//  TastingNoteDTO.swift
//  MixbyPreview
//
//  Created by Ys on 11/29/24.
//

import Foundation

public struct TastingNoteDTO: Codable {
    var code: String
    var english_name: String
    var korean_name: String
    var drinkDate: String
    var eval: Int = -1
    var sweetness: Int = -1
    var sourness: Int = -1
    var alcohol: Int = -1
    
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(self) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
    
    public static func toEval(n: Int) -> String {
        switch n {
        case -1 :
            return "아직 작성하지 않았습니다."
        case 0 :
            return "매우 부족해요"
        case 1:
            return "부족해요"
        case 2:
            return "조금 부족해요"
        case 3:
            return "최고에요!"
        case 4:
            return "조금 과해요"
        case 5:
            return "과해요"
        case 6:
            return "매우 과해요"
        default:
            return String(n)
        }
    }
}

