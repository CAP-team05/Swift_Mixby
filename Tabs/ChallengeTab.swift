//
//  SwiftUIView.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct ChallengeTab: View {
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: UIScreen.screenHeight * 0.3)
                .opacity(0.1)
            
            ScrollView(.vertical) {
                Spacer().frame(height: 10)
                ForEach(0..<5) { _ in
                    ChallengeCard()
                    Spacer().frame(height: 20)
                }
                // bottom dummy
                Spacer().frame(height: 200)
            }
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
    }
}
