//
//  RecipeCard.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct RecipeCard: View {
    var recipeDTO: RecipeDTO
    
    var body: some View {
        let cardWidth: CGFloat = 120
        let cardHeight: CGFloat = 180
        let haves = recipeDTO.have.split(separator: "-")
        
        ZStack{
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: cardWidth, height: cardHeight)
                .background(Color(red: 0.11, green: 0.11, blue: 0.22))
                .cornerRadius(30)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                )
            
            let image_url = URL(string: "http://cocktail.mixby.kro.kr:2222/recipe/image="+recipeDTO.english_name)
            
            AsyncImage(url: image_url) { result in
                result.image?
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: cardWidth, height: cardWidth)
            .opacity(haves[0] == haves [1] ? 1 : 0.05)
            .cornerRadius(30)
            .shadow(
                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
            )
            .offset(y: -(cardHeight-cardWidth)/2)
            
            Text(recipeDTO.korean_name)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.yellow)
                .font(.gbRegular14)
                .offset(y: 50)
            
            Text("#\(recipeDTO.tag1) #\(recipeDTO.tag2)")
                .foregroundColor(Color.white)
                .font(.gbRegular10)
                .offset(y: 65)
            
            Text("\(haves[0])/\(haves[1])")
                .foregroundColor(Color.yellow)
                .font(.gbRegular10)
                .offset(y: 80)
        }
        .frame(width: cardWidth, height: cardHeight)
    }
}
