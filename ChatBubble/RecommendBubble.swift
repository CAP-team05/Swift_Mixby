//
//  RecommandCard.swift
//  mixby2
//
//  Created by Anthony on 12/7/24.
//

import SwiftUI

struct RecommendBubble: View {
    
    var recipeDTO: RecipeDTO
    var reason: String
    var tag: String
    
    var body: some View {
        
        HStack {
            Spacer().frame(width: 10)
            ZStack {
                Rectangle()
                    .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))
                    .foregroundColor(Color.mixbyColor2.opacity(0.1))
                    .frame(width: UIScreen.screenWidth-120, height: 160)
                    .shadow(color: Color.mixbyShadow, radius: 4)
                    .mask(
                        BubbleShape(myMessage: false)
                    )
                
                VStack {
                    HStack {
                        let image_url = URL(string: "http://cocktail.mixby.kro.kr:2222/recipe/image="+recipeDTO.english_name)
                        
                        Spacer().frame(width: 15)
                        
                        AsyncImage(url: image_url) { result in
                            result.image?
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                        .shadow(color: Color.white.opacity(1), radius: 2)
                        .offset(y: 10)
                        
                        Spacer()
                        
                        VStack (spacing: 20) {
                            Text(recipeDTO.korean_name)
                                .font(.gbRegular18)
                                .foregroundColor(.yellow)
                            
                            Text("#\(tag)")
                                .font(.gbRegular16)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text(reason)
                        .font(.gbRegular16)
                        .foregroundColor(.white)
                        .frame(width: 260)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    Spacer()
                }
                .frame(width: UIScreen.screenWidth-120, height: 160)
            }
            Spacer()
        }
        .frame(height: 205)
    }
}
