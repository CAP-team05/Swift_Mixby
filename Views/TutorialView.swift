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
            BackGround(bgPos: bgPos)
            
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
            
            BartenderIsland(showBartender: $showBartender)
        }
    }
    
    private func switchTab(_ newValue: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            bgPos = (newValue - 3) * -20
            currentTab = newValue
        }
    }
}
