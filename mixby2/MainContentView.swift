//
//  ContentView.swift
//  mixby2
//
//  Created by Anthony on 11/26/24.
//

import SwiftUI

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

struct MainContentView: View {
    
    @AppStorage("ownedTools") var ownedTools: [String] = []
    
    @Binding var ownedIngs: [String]
    
    @State var tabSelection = 3
    @State var currentTab = 3
    @State var bgPos: Int = 0
    @State var showBartender: Bool = true
    
    @State var isLoading: Bool = false
    
    
    var body: some View {
        NavigationView {
            TabView {
                ZStack {
                    // Background with animation
                    BackGround(bgPos: bgPos)
                    
                    // Conditional rendering based on `currentTab`
                    if currentTab == 1 {
                        RecipeTab(
                            tabSelection: $tabSelection,
                            isLoading: $isLoading,
                            ownedIngs: $ownedIngs,
                            ownedTools: $ownedTools
                        )
                        .toolbar(.hidden, for: .tabBar)
                    }
                    if currentTab == 2 {
                        CabinetTab(ownedIngs: $ownedIngs, ownedTools: $ownedTools)
                            .toolbar(.hidden, for: .tabBar)
                    }
                    if currentTab == 3 {
                        HomeTab()
                            .toolbar(.hidden, for: .tabBar)
                    }
                    if currentTab == 4 {
                        NoteTab(isLoading: $isLoading)
                            .toolbar(.hidden, for: .tabBar)
                    }
                    if currentTab == 5 {
                        ChallengeTab()
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }
            .overlay(alignment: .bottom) {
                // Custom tab bar
                CustomTabBar(tabSelection: $tabSelection, isLoading: $isLoading)
                    .frame(width: 400)
                    .onChange(of: tabSelection) { oldValue, newValue in
                        if !isLoading {
                            switchTab(newValue)
                        }
                    }
                
                // Bartender
                BartenderIsland(showBartender: $showBartender)
                
                BartenderBubble(currentTab: $currentTab)
            }
        }
        .tint(.white)
    }
    
    /// Handles tab switching with animation
    private func switchTab(_ newValue: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            bgPos = (newValue - 3) * -20
            currentTab = newValue
        }
    }
}

