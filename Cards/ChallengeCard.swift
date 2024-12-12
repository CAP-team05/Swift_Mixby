//
//  ChallengeCard.swift
//  mixby2
//
//  Created by Anthony on 12/7/24.
//

import SwiftUI

struct ChallengeCard: View {
    
    var isUnlocked: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))
                .foregroundColor(Color.white)
                .opacity(0.2)
                .shadow(color: Color.mixbyShadow, radius: 4)
                .cornerRadius(50)
            
            if isUnlocked {
                Text("도전과제 설명")
                    .font(.gbRegular16)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.screenWidth-60, height: 40)
            } else {
                Image(systemName: "lock")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        }
        .frame(width: UIScreen.screenWidth-40, height: 40)
    }
}
