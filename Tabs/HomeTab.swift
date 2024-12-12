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
    @State var weatherName: String
    
    var ownedTools: [String]
    var ownedIngs: [String]
    
    var body: some View {
        VStack {
            Spacer().frame(height: 150)
            
            ChatScrollView(
                appJustLaunched: $appJustLaunched,
                userName: userName,
                weatherName: weatherName,
                ownedTools: ownedTools, ownedIngs: ownedIngs)
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .onAppear {
            print(weatherName)
        }
    }
}
