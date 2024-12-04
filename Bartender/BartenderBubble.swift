//
//  TutorialBubble.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct  BartenderBubble: View {
    @Binding var currentTab: Int
    
    @State private var showComment: Bool = true
    @State private var userName: String = ""
    
    private let recipeHandler = RecipeHandler()
    private let drinkHandler = DrinkHandler()
    private let userHandler = UserHandler()
    
//    private let drinkHandler = DrinkHandler()
    
    // Speech Bubble
    var body: some View {
        
        let comments: [String] = [
            "레시피 개수: \(recipeHandler.fetchAllRecipes().count)",
            "상품 개수: \(drinkHandler.fetchAllDrinks().count)",
            "환영합니다. \(userHandler.fetchAllUsers().last!.name)님!",
            "테이스팅 노트",
            "설정"
        ]
        
        
        ZStack {
            Rectangle()
                .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))
                .foregroundColor(Color.white)
                .opacity(0.2)
                .cornerRadius(30)
            
            Text(comments[currentTab-1])
                .font(.gbRegular22)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .lineSpacing(10)
                .opacity(showComment ? 0.8 : 0)
                .frame(
                    width: showComment ? UIScreen.screenWidth-60 : 60,
                    height: showComment ? 100 : -40
                )
        } // card bg
        .frame(
            width: UIScreen.screenWidth-40,
            height: 100
        )
        .offset(y: UIScreen.screenHeight * -0.5 + 185)
    }
}
