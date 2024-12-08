//
//  ChallengeCard.swift
//  mixby2
//
//  Created by Anthony on 12/7/24.
//

import SwiftUI

struct ChallengeCard: View {
    var body: some View {
        ZStack {
            Rectangle()
                .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))
                .foregroundColor(Color.white)
                .opacity(0.4)
                .frame(
                    width: UIScreen.screenWidth-40,
                    height: 100
                )
                .shadow(color: Color.mixbyShadow, radius: 4)
                .cornerRadius(26)
            
            VStack {
                Spacer().frame(height: 5)
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.mixbyColor1)
                        .cornerRadius(30)
                        .opacity(0.7)
                        .frame(
                            width: UIScreen.screenWidth-50,
                            height: 40
                        )
                        .shadow(color: Color.mixbyShadow, radius: 4)
                    Text("도전과제 이름")
                        .font(.gbRegular16)
                        .foregroundColor(.yellow)
                }
                .frame(
                    width: UIScreen.screenWidth-50,
                    height: 40
                )
                Spacer()
                Text("도전과제 설명")
                    .font(.gbRegular14)
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
        .frame(
            width: UIScreen.screenWidth-20,
            height: 100
        )
    }
}
