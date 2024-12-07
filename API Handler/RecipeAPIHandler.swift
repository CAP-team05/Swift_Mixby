//
//  GetProductInfo.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import Foundation

func getKeywordsByDrinkDTO (drinks: [DrinkDTO]) -> String {
    var key = ""
    for drink in drinks {
        key += drink.baseCode
    }
    return key
}

func getRecipeDTOListWithKeywords (key: String) -> [RecipeDTO] {
    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/recipe/with="+key)
    let array = json.split(separator: "},")
    
    var recipes: [RecipeDTO] = []
    
    for a in array {
        let code = getTagFromJson(json: String(a), tag: "code")
        let have = getTagFromJson(json: String(a), tag: "have")
        
        if isRecipeExist(code: code) {
            let recipeDTO = RecipeDTO(
                code: code,
                english_name: getTagFromJson(json: String(a), tag: "english_name"),
                korean_name: getTagFromJson(json: String(a), tag: "korean_name"),
                tag1: getTagFromJson(json: String(a), tag: "tag1"),
                tag2: getTagFromJson(json: String(a), tag: "tag2"),
                have: have
            )
            recipes.append(recipeDTO)
        }
    }
    return recipes
}

//func getRecipeIngredients(code: String) -> [IngredientDTO] {
//    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/recipe/code="+code)
//    
//    if isRecipeExist(code: code) {
//        let ingredient = IngredientDTO(
//            
//        )
//    }
//}

func isRecipeExist(code: String) -> Bool {
    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/recipe/code="+code)
    
    if json.contains("no result found") {
        return false
    } else { return true }
}
