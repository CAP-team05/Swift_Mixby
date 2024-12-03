//
//  GetProductInfo.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import Foundation

func getAllIngredientsFromAPI() -> [IngredientDTO] {
    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/ing/all")
    let array = json.split(separator: "},")
    
    var ingredients: [IngredientDTO] = []
    
    for a in array {
        let ingredientDTO = IngredientDTO(
            name: getTagFromJson(json: String(a), tag: "name"),
            code: getTagFromJson(json: String(a), tag: "code")
        )
        ingredients.append(ingredientDTO)
    }
    
    return ingredients
}
