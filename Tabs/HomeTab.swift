//
//  HomeTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct HomeTab: View {
    @Binding var appJustLaunched: Bool
    
    @State var userName: String
    
    var ownedTools: [String]
    var ownedIngs: [String]
    
    var body: some View {
        ZStack {
            VStack (spacing: 0) {
                // title dummy
                Spacer().frame(height: UIScreen.screenHeight * 0.18)
                ChatScrollView(appJustLaunched: $appJustLaunched, userName: userName, ownedTools: ownedTools, ownedIngs: ownedIngs)
            }
            
        }
        .ignoresSafeArea()
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
    }
}
