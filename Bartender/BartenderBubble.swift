//
//  TutorialBubble.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct  BartenderBubble: View {
    @Binding var currentTab: Int
    
    @State private var showComment: Bool = false
    @State private var showBubble: Bool = false
    @State private var userName: String = ""
    
    //    private let drinkHandler = DrinkHandler()
    
    // Speech Bubble
    var body: some View {
        
        let comments: [String] = [
            "레시피 개수: \(RecipeHandler.searchAll().count)",
            "상품 개수: \(DrinkHandler.searchAll().count)",
            "환영합니다. \(UserHandler.searchAll().count)님!",
            "테이스팅 노트",
            "도전과제"
        ]
        
        
        ZStack {
            Rectangle()
                .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))
                .foregroundColor(Color.white)
                .opacity(showBubble ? 0.2 : 0)
                .cornerRadius(30)
                .frame(
                    width: showBubble ? UIScreen.screenWidth-40 : 0,
                    height: showBubble ? 100 : 0
                )
            
            Text(comments[currentTab-1])
                .font(.gbRegular22)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .lineSpacing(10)
                .opacity(showBubble && showComment ? 0.8 : 0)
                .frame(
                    width: showBubble ? UIScreen.screenWidth-60 : 0,
                    height: showBubble ? 100 : 0
                )
                .onChange(of: showBubble) { old, new in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showComment = showBubble
                    }
                }
            
        } // card bg
        .offset(y: showBubble ? UIScreen.screenHeight * -0.5 + 185 : UIScreen.screenHeight * -0.5 + 85)
        .onChange(of: currentTab) { new, old in
            withAnimation(.easeInOut(duration: 0.3)) {
                showBubble = currentTab != 3
            }
        }
    }
}
