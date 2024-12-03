//
//  ProductView.swift
//  mixby2
//
//  Created by Anthony on 11/28/24.
//

import SwiftUI

struct ProductView: View {
    @Environment(\.presentationMode) private var presentationMode : Binding<PresentationMode>
    
    var drinkDTO: DrinkDTO
    
    private let drinkHandler = DrinkHandler()
    
    var body: some View {
    
        ZStack {
            ViewBackground()
            
            Spacer()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            drinkHandler.deleteDrink(drink: drinkDTO)
                            generateRecipeDTOsByGetKeywords(doPlus: false, keys: [])
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "trash")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                        })
                    }
                }
            
            VStack {
                Spacer().frame(height: 70)
                
                let image_url = URL(string: "http://cocktail.mixby.kro.kr:2222/drink/image="+drinkDTO.code)
                
                AsyncImage(url: image_url) { result in
                    result.image?
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 300, height: 300)
                .cornerRadius(150)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                )
                
                Spacer().frame(height: 40)
                
                VStack (spacing: 30) {
                    Text(drinkDTO.name)
                        .font(.gbBold30)
                        .foregroundColor(.yellow)
                    Text(drinkDTO.type)
                        .font(.gbRegular22)
                        .foregroundColor(.white)
                    HStack (spacing: 40) {
                        Text(drinkDTO.volume)
                            .font(.gbRegular22)
                            .foregroundColor(.white)
                        Text(drinkDTO.alcohol)
                            .font(.gbRegular22)
                            .foregroundColor(.white)
                    }
                    Spacer().frame(height: 20)
                    Text(drinkDTO.description)
                        .font(.gbRegular24)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(8)
                        .opacity(0.7)
                }
                
                Spacer()
                
            }.frame(width: UIScreen.screenWidth - 40, height: UIScreen.screenHeight)
        }
    }
}
