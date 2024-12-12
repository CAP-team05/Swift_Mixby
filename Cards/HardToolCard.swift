//
//  IngredientCard.swift
//  mixby2
//
//  Created by Anthony on 12/2/24.
//

import SwiftUI

struct HardToolCard: View {
    @Binding var ownedTools: [String]
    
    @State var name: String
    @State var description: String
    @State var isOwned: Bool = false
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.mixbyColor1.opacity(isOwned ? 0.8 : 0.3))
            
            HStack {
                Image(systemName: isOwned ? "checkmark.circle" : "circle")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
                
                Spacer()
                
                VStack (spacing: 5) {
                    Text(name)
                        .font(.gbRegular14)
                        .foregroundColor(.yellow)
                    Text(description)
                        .font(.gbRegular12)
                        .foregroundColor(.white)
                }
                
                Spacer()
                
            } // HStack
            .padding(10)
            
        } // ZStack
        .frame(height: 60)
        .onTapGesture {
            if !isOwned {
                ownedTools.append(name)
                print("is Owned")
            }
            else {
                ownedTools.removeAll(where: { $0 == name })
                print("is not Owned")
            }
            isOwned.toggle()
        }
    }
}
