//
//  ChallengeDTO.swift
//  mixby2
//
//  Created by Ys on 12/12/24.
//

import Foundation

public struct ChallengeDTO: Codable {
    var id: Int
    var title: String
    var description: String
    var isUnlocked: Bool
    
    public init(id: Int, title: String, description: String, isUnlocked: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.isUnlocked = isUnlocked
    }
    
    mutating func unlocked() {
        isUnlocked = true
    }
}
