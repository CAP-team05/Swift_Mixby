//
//  GetProductInfo.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import Foundation

func getDrinkDTOFromApi(barcode: String) -> DrinkDTO
{
    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/drink/code="+barcode)
    
    let drinkDTO = DrinkDTO(
        
        code: getTagFromJson(json: json, tag: "code"),
        name: getTagFromJson(json: json, tag: "name"),
        baseCode: getTagFromJson(json: json, tag: "baseCode"),
        type: getTagFromJson(json: json, tag: "type"),
        volume: getTagFromJson(json: json, tag: "volume"),
        alcohol: getTagFromJson(json: json, tag: "alcohol"),
        description: getTagFromJson(json: json, tag: "description")
    )
    
    return drinkDTO
}

func isDrinkExist(barcode: String) -> Bool {
    print("isDrinkExist: \(barcode)")
    
    if barcode.contains("http") {
        return false
    }
    
    let json: String = GetJsonFromURL(url: "http://cocktail.mixby.kro.kr:2222/drink/code="+barcode)
    
    if json.contains("no result found") {
        return false
    }
    else {
        return true
    }
}
