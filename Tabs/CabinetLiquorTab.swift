//
//  CabinetDrinkTab.swift
//  mixby2
//
//  Created by Anthony on 12/1/24.
//

import SwiftUI

struct CabinetLiquorTab: View {
    @Binding var pageRefreshed: Bool
    
    @Binding var ownedIngs: [String]
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    
    var body: some View {
        let ingredientDTOArray = IngredientHandler.searchAll()
        
        ScrollView(.vertical) {
            Spacer().frame(height: 10)
            
            LazyVGrid(columns: columns, spacing: 20) {
                
                ForEach(0..<ingredientDTOArray.count, id: \.self) { i in
                    let ingredientDTO = ingredientDTOArray[i]
                    if ingredientDTO.code.first == "2" {
                        IngredientCard(
                            ownedIngs: $ownedIngs,
                            isOwned: ownedIngs.contains(ingredientDTO.code),
                            ingredientDTO: ingredientDTO
                        )
                    }
                }
            }
            .frame(width: UIScreen.screenWidth - 20)
            
            // bottom dummy
            Spacer().frame(height: 200)
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight-300)
    }
}
