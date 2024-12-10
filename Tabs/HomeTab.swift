//
//  HomeTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct HomeTab: View {
    @Binding var lastUpdate: Date
    
    var ownedTools: [String]
    
    var body: some View {
        ZStack {
            Rectangle()
                .opacity(0.1)
            
            
            VStack (spacing: 0) {
                // title dummy
                Spacer().frame(height: UIScreen.screenHeight * 0.18)
                ChatScrollView(lastUpdate: $lastUpdate, ownedTools: ownedTools)
            }
            
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
    }
}
