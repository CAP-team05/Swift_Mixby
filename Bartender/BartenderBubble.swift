//
//  TutorialBubble.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct  BartenderBubble: View {
    @Binding var currentTab: Int
    @Binding var showBartender: Bool
    
    @State var userName: String
    
    // Speech Bubble
    var body: some View {
        
        let comments: [[String]] = [
            ["레시피를 해금하고 싶다면 재료를 등록해보세요."],
            ["\(userName)님의 술은 잘 보관하고 있습니다."],
            [""],
            ["테이스팅 노트를 등록하면 더 정확한 추천이 가능해요."],
            [""]
        ]
        
        ZStack {
            Rectangle()
                .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))
                .foregroundColor(Color.white)
                .opacity(showBartender ? 0.2 : 0)
                .cornerRadius(30)
                .frame(
                    width: UIScreen.screenWidth-40,
                    height: 100
                )
            
            Text(comments[currentTab-1][0])
                .font(.gbRegular22)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .lineSpacing(10)
                .opacity(0.8)
                .frame(
                    width: UIScreen.screenWidth-60,
                    height: 100
                )
            
        } // card bg
        .offset(y: showBartender ? UIScreen.screenHeight * -0.5 + 185 : UIScreen.screenHeight * -0.5 + 85)
        .opacity(showBartender ? 1 : 0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                if currentTab != 3 {
                    showBartender.toggle()
                }
            }
        }
    }
}
