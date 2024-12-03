//
//  ProductCard.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct ProductCard: View {
    
    var drinkDTO: DrinkDTO
    
    var body: some View {
        let url = URL(string: "http://cocktail.mixby.kro.kr:2222/drink/image="+drinkDTO.code)
        
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .background(Color.mixbyColor1)
                .shadow(color: Color.mixbyShadow, radius: 4, y: 4)
                .frame(width: 122, height: 160)
                .cornerRadius(19)
                .offset(y:20)
            
            AsyncImage(url: url) { result in
                result.image?
                    .resizable()
                    .scaledToFill()
            }
            .foregroundColor(.clear)
            .frame(width: 122, height: 122)
            .cornerRadius(100)
            .shadow(color: Color.mixbyShadow, radius: 4, y: 4)
            .offset(y: -35)
            
            Text(drinkDTO.name)
                .foregroundColor(Color.yellow)
                .font(.gbRegular16)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .offset(y: 50)
            
            Text(drinkDTO.type)
                .font(.gbRegular14)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .frame(width: 122, height: 200)
                .offset(y: 85)
        }
    }
}
