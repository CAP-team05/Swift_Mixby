//
//  AdditionCard.swift
//  mixby2
//
//  Created by Anthony on 11/30/24.
//

import SwiftUI

struct AdditionCard: View {
    private let drinkHandler = DrinkHandler()
    
    var code: String
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(height: 60)
                .foregroundColor(.white.opacity(0.2))
            
            let url = URL(string: "http://cocktail.mixby.kro.kr:2222/drink/image="+code)
            
            if isDrinkExist(barcode: code) {
                HStack {
                    AsyncImage(url: url) { result in
                        result.image?
                            .resizable()
                            .scaledToFill()
                    }
                    .foregroundColor(.clear)
                    .frame(width: 60, height: 60)
                    .cornerRadius(100)
                    .shadow(color: Color.mixbyShadow, radius: 4, y: 4)
                    
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        Text(getDrinkDTOFromApi(barcode: code).name)
                            .font(.gbBold20)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(getDrinkDTOFromApi(barcode: code).type)
                            .font(.gbRegular16)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
        } // ZStack
        .frame(width: UIScreen.screenWidth - 60)
    }
}
