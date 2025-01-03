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

func getRecipeDTObyName(name: String) -> RecipeDTO {
    let modiName = name.replacingOccurrences(of: " ", with: "-")
    let a: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/recipe/name="+modiName)
    
    let recipeDTO = RecipeDTO(
        code: getTagFromJson(json: String(a), tag: "code"),
        english_name: getTagFromJson(json: String(a), tag: "english_name"),
        korean_name: getTagFromJson(json: String(a), tag: "korean_name"),
        tag1: getTagFromJson(json: String(a), tag: "tag1"),
        tag2: getTagFromJson(json: String(a), tag: "tag2"),
        have: ""
    )
    return recipeDTO
}

func getRecipeCodeByName(name: String) -> String {
    let modiName = name.replacingOccurrences(of: " ", with: "-")
    let a: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/recipe/name="+modiName)
    if a.contains("no result found") {
        return "no result"
    }
    return getTagFromJson(json: String(a), tag: "code")
}

func getInstructionByCode(code: String) -> [Substring] {
    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/recipe/code="+code)
    
    if isRecipeExist(code: code) {
        var inst = json.split(separator: "instructions")[1]
        inst = inst.split(separator: "]")[0]
        var inst2 = inst.replacingOccurrences(of: "\": [", with: "")
        inst2 = inst2.replacingOccurrences(of: "  ", with: "")
        return inst2.split(separator: ",\n")
    }
    return []
}

func isRecipeExist(code: String) -> Bool {
    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/recipe/code="+code)
    
    if json.contains("no result found") {
        return false
    } else { return true }
}


func getRandomRecipe() -> RecipeDTO {
    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/recipe/random")
    
    let recipeDTO = RecipeDTO(
        code: getTagFromJson(json: json, tag: "code"),
        english_name: getTagFromJson(json: json, tag: "english_name"),
        korean_name: getTagFromJson(json: json, tag: "korean_name"),
        tag1: getTagFromJson(json: json, tag: "tag1"),
        tag2: getTagFromJson(json: json, tag: "tag2"),
        have: ""
    )
    return recipeDTO
}
