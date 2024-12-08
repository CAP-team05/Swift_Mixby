//
//  BartenderMessageBubble.swift
//  mixby2
//
//  Created by Anthony on 12/8/24.
//

import SwiftUI

struct BartenderChatBubble: View {
    
    var body: some View {
        HStack {
            Spacer().frame(width: 10)
            ZStack {
                Rectangle()
                    .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))
                    .foregroundColor(Color.mixbyColor2.opacity(0.1))
                    .frame(width: UIScreen.screenWidth-180, height: 80)
                    .shadow(color: Color.mixbyShadow, radius: 4)
                    .mask(
                          BubbleShape(myMessage: false)
                    )
                
                VStack {
                    Spacer()
                    
                    Text("환영합니다.")
                        .font(.gbRegular16)
                        .foregroundColor(.yellow)
                    Spacer()
                    
                    Text("어떤 술을 추천드릴까요?")
                        .font(.gbRegular16)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            Spacer()
        }
        .frame(height: 85)
    }
}

#Preview {
    BartenderChatBubble()
}
