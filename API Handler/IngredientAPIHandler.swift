//
//  GetProductInfo.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import Foundation

struct recipeIngs {
    let name: String
    let code: String
    let amount: String
    let unit: String
}

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

func getRecipeIngredients(recipe: RecipeDTO) -> [recipeIngs] {
    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/recipe/code="+recipe.code)
    
    let arr1 = json.split(separator: "\"ingredients\"")
    let arr2 = arr1[1].split(separator: "]")[0]
    let ings = arr2.split(separator: "{")
    
    var recipes: [recipeIngs] = []
    
    for index in (1..<ings.count) {
        let name = getTagFromJson(json: String(ings[index]), tag: "name")
        let code = getTagFromJson(json: String(ings[index]), tag: "code")
        let amount = getTagFromJson(json: String(ings[index]), tag: "amount")
        let unit = getTagFromJson(json: String(ings[index]), tag: "unit")
        
        let recipe = recipeIngs(name: name, code: code, amount: amount, unit: unit.contains("}") ? "" : unit)
        recipes.append(recipe)
    }
    
    return recipes
}
