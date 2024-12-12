//
//  TutorialTab.swift
//  mixby2
//
//  Created by Anthony on 12/1/24.
//

import SwiftUI

struct TutorialView: View {
    @Binding var showTutorial: Bool
    
    @State var tabSelection = 3
    @State var currentTab = 3
    
    @State var showCustomBar: Bool = false
    @State var showBartender: Bool = true
    @State var isLoading: Bool = false
    @State var bgPos: Int = 0
    
    
    var body: some View {
        TabView {
            ZStack() {
                let bgSize: CGFloat = 500
                // Background gradient
                
                
                Image("city")
                    .resizable()
                    .frame(width: UIScreen.screenWidth*1.5, height: UIScreen.screenHeight*1.5)
                    .offset(y: 100)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.black, Color.white]), startPoint: .topTrailing, endPoint: .bottomLeading)
                    )
                    .opacity(0.7)
                
                // Front Shadow
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                    .background(Color(red: 0.20, green: 0.20, blue: 0.36).opacity(0.60))
                
                Image("building")
                    .resizable()
                    .frame(width: bgSize, height: bgSize)
                    .offset(x: CGFloat(bgPos-20), y: 300)
                    .opacity(showCustomBar ? 1 : 0)
                
                Rectangle()
                    .opacity(showCustomBar ? 0.1 : 0.5)
                    .mask(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                
            }
        }
        
        .overlay(alignment: .bottom) {
            if showCustomBar {
                CustomTabBar(tabSelection: $tabSelection, isLoading: $isLoading)
                    .frame(width: 400)
                    .onChange(of: tabSelection) { oldValue, newValue in
                        if !isLoading {
                            switchTab(newValue)
                        }
                    }
            }
            
            TutorialBubble(
                tabSelection: $tabSelection,
                showCustomBar: $showCustomBar,
                showTutorial: $showTutorial
            )
            .ignoresSafeArea()
            
            BartenderIsland(currentTab: $currentTab, showBartender: $showBartender)
        }
    }
    
    private func switchTab(_ newValue: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            bgPos = (newValue - 3) * -20
            currentTab = newValue
        }
    }
}
