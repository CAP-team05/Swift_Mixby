//
//  TastingNoteAPIHandler.swift
//  MixbyPreview
//
//  Created by Ys on 11/30/24.
//

import Foundation

class TastingNoteAPIHandler {
    private let apiUrl: String = "http://127.0.0.1:2222"
}

func isRecipeCodeInTastingNotes(recipe: RecipeDTO, tastingNotes: [TastingNoteDTO]) -> Bool {
    return tastingNotes.contains { $0.code == recipe.code }
}

func generateTastingsNoteByRecipeDTOs(recipeDTOs: [RecipeDTO]) {
    let tastingNoteDTOs = TastingNoteHandler.searchAll()
    
    for recipeDTO in recipeDTOs {
        let code = recipeDTO.code
        let english_name = recipeDTO.english_name
        let korean_name = recipeDTO.korean_name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let drinkDate = dateFormatter.string(from: Date())
        
        let tastingNoteDTO = TastingNoteDTO(
            code: code,
            english_name: english_name,
            korean_name: korean_name,
            drinkDate: drinkDate
        )
        if !isRecipeCodeInTastingNotes(recipe: recipeDTO, tastingNotes: tastingNoteDTOs) {
            TastingNoteHandler.insert(note: tastingNoteDTO)
            print("new note added")
        }
    }
}
