//
//  IngredientCard.swift
//  mixby2
//
//  Created by Anthony on 12/2/24.
//

import SwiftUI

struct IngredientCard: View {
    @Binding var ownedIngs: [String]
    
    @State var isOwned: Bool
    
    var ingredientDTO: IngredientDTO
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.mixbyColor1.opacity(isOwned ? 0.8 : 0.3))
            
            HStack {
                Image(systemName: isOwned ? "checkmark.circle" : "circle")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(ingredientDTO.name)
                    .font(.gbRegular14)
                    .foregroundColor(isOwned ? .yellow : .white)
                
                Spacer()
                
            } // HStack
            .padding(10)
            
        } // ZStack
        .frame(height: 60)
        .onTapGesture {
            if isOwned {
                ownedIngs.removeAll { $0 == ingredientDTO.code }
            }
            else {
                ownedIngs.append(ingredientDTO.code)
            }
            isOwned.toggle()
        }
    }
}
