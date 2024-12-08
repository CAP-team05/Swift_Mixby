//
//  RecommandCard.swift
//  mixby2
//
//  Created by Anthony on 12/7/24.
//

import SwiftUI

struct RecommandBubble: View {
    
    var recipeDTO: RecipeDTO
    
    var body: some View {
        HStack {
            Spacer().frame(width: 10)
            ZStack {
                Rectangle()
                    .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))
                    .foregroundColor(Color.mixbyColor2.opacity(0.1))
                    .frame(width: UIScreen.screenWidth-60, height: 200)
                    .shadow(color: Color.mixbyShadow, radius: 4)
                    .mask(
                        BubbleShape(myMessage: false)
                    )
                
                VStack {
                    Spacer().frame(height: 10)
                    HStack {
                        let image_url = URL(string: "http://cocktail.mixby.kro.kr:2222/recipe/image="+recipeDTO.english_name)
                        
                        Spacer().frame(width: 15)
                        
                        AsyncImage(url: image_url) { result in
                            result.image?
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 100, height: 100)
                        .cornerRadius(12)
                        .shadow(color: Color.white.opacity(1), radius: 2)
                        
                        Spacer()
                        
                        VStack (spacing: 20) {
                            Text(recipeDTO.korean_name)
                                .font(.gbRegular18)
                                .foregroundColor(.yellow)
                            
                            Text("#\(recipeDTO.tag1) #\(recipeDTO.tag2)")
                                .font(.gbRegular16)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Text("어쩌구 저쩌구")
                        .font(.gbRegular14)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .frame(width: UIScreen.screenWidth-60, height: 200)
            }
            Spacer()
        }
        .frame(height: 205)
    }
}
