//
//  ChallengeCard.swift
//  mixby2
//
//  Created by Anthony on 12/7/24.
//

import SwiftUI

struct ChallengeCard: View {
    @State var isTouch: Bool = false
    let title: String
    let description: String
    let isUnlocked: Bool
    
    var body: some View {
        ZStack {
            Capsule()
                .stroke(isUnlocked ? Color.mixbyColor3 : Color.white, lineWidth: 3)
                .shadow(color: Color.white, radius: isUnlocked ? 2 : 0)
                .frame(width: UIScreen.screenWidth-40, height: 60)
            
            if isUnlocked || isTouch {
                Text(title)
                    .font(.gbRegular20)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.screenWidth-80, height: 60)
            } else {
                Image(systemName: "lock")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        }
        .frame(width: UIScreen.screenWidth, height: 60)
        .onTapGesture {
            isTouch.toggle()
        }
    }
}
