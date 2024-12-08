//
//  HomeTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct HomeTab: View {
    
    var ownedTools: [String]
    
    var body: some View {
        ZStack {
            //            Text(String(describing: UserHandler.searchAll().last?.persona))
            //                .font(.gbRegular20)
            //                .foregroundColor(.white)
            //                .multilineTextAlignment(.center)
            //                .frame(width: UIScreen.screenWidth - 20)
            
            Rectangle()
                .opacity(0.1)
            
            
            VStack (spacing: 0) {
                // title dummy
                Spacer().frame(height: UIScreen.screenHeight * 0.18)
                ChatScrollView(ownedTools: ownedTools)
            }
            
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
    }
}

#Preview {
    HomeTab(ownedTools: [""])
}
