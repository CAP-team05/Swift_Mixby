//
//  RecipeView.swift
//  mixby2
//
//  Created by Anthony on 11/28/24.
//

import SwiftUI

struct RecipeView: View {
    
    var recipeDTO: RecipeDTO
    
    @Environment(\.presentationMode) private var presentationMode : Binding<PresentationMode>
    
    private let recipeHandler = RecipeHandler()
    
    var body: some View {
        
        ZStack {
            ViewBackground()
            
//            Spacer()
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            presentationMode.wrappedValue.dismiss()
//                        }, label: {
//                            Image(systemName: "note.text")
//                                .font(.system(size: 14))
//                                .foregroundColor(.white)
//                        })
//                    }
//                }
            
            VStack {
                Spacer().frame(height: 70)
                
                let image_url = URL(string: "http://cocktail.mixby.kro.kr:2222/recipe/image="+recipeDTO.english_name)
                
                AsyncImage(url: image_url) { result in
                    result.image?
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 300, height: 300)
                .cornerRadius(50)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                )
                
                Spacer().frame(height: 40)
                
                VStack (spacing: 30) {
                    Text(recipeDTO.korean_name)
                        .font(.gbBold30)
                        .foregroundColor(.yellow)
                    
                    Text("#\(recipeDTO.tag1) #\(recipeDTO.tag2)")
                        .font(.gbRegular22)
                        .foregroundColor(.white)
                    
//                    let ings = getRecipeIngredients(code: recipeDTO.code)
                    
                    Spacer().frame(height: 10)
                    
//                    ForEach(0..<ings.count, id: \.self) { i in
//                        HStack {
//                            Text(ings[i].name)
//                                .font(.gbRegular24)
//                                .foregroundColor(.white)
//                            
//                            Text(ings[i].amount)
//                                .font(.gbRegular24)
//                                .foregroundColor(.white)
//                            
//                            Text(ings[i].unit)
//                                .font(.gbRegular24)
//                                .foregroundColor(.white)
//                        }
//                    }
                    
                    Spacer()
                }
                
                Spacer()
                
            }.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        }
    }
}
