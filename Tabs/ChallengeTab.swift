//
//  SwiftUIView.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct ChallengeTab: View {
    let challengeHandler = ChallengeHandler.shared
    
    var body: some View {
        VStack (spacing: 0) {
            // title dummy
            Rectangle()
                .frame(height: UIScreen.screenHeight * 0.3)
                .opacity(0)
            
            ScrollView(.vertical) {
                VStack (spacing: 20) {
                    Spacer().frame(height: 10)
                    
                    // Display unlocked challenges first
                    ForEach(Array(challengeHandler.challenges.enumerated().filter({ $0.element.isUnlocked }).sorted { !$1.element.isUnlocked && $0.element.isUnlocked }), id: \.element.id) { index, challenge in
                        ChallengeCard(title: challenge.title, description: challenge.description, isUnlocked: challenge.isUnlocked)
                    }

                    // Then display locked challenges
                    ForEach(Array(challengeHandler.challenges.enumerated().filter({ !$0.element.isUnlocked }).sorted { !$1.element.isUnlocked && $0.element.isUnlocked }), id: \.element.id) { index, challenge in
                        ChallengeCard(title: challenge.title, description: challenge.description, isUnlocked: challenge.isUnlocked)
                    }

                    // bottom dummy
                    Spacer().frame(height: 200)
                }
            }
            .frame(width: UIScreen.screenWidth)
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
    }
}
