//
//  SwiftUIView.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct ChallengeTab: View {
    var body: some View {
        VStack (spacing: 0) {
            // title dummy
            Rectangle()
                .frame(height: UIScreen.screenHeight * 0.3)
                .opacity(0)
            
            ScrollView(.vertical) {
                VStack (spacing: 20) {
                    Spacer().frame(height: 10)
                    
                    ForEach(0..<5) { _ in
                        ChallengeCard()
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
