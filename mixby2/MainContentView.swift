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
    @AppStorage("isDataChanged") var isDataChanged: Bool = false
    
    @Binding var ownedIngs: [String]
    
    @State var weatherName: String
    @State var tabSelection = 3
    @State var currentTab = 3
    @State var bgPos: Int = 0
    @State var showBartender: Bool = false
    
    @State var isLoading: Bool = false
    @State var appJustLaunched: Bool = true
    
    @State private var userName: String = UserHandler.shared.searchAll().last?.name ?? "noname"
    
    var body: some View {
        NavigationView {
            TabView {
                ZStack {
                    // Background with animation
                    BackGround(bgPos: bgPos, weatherName: weatherName)
                        
                        Group {
                            // Conditional rendering based on `currentTab`
                            if currentTab == 1 {
                                RecipeTab(
                                    tabSelection: $tabSelection,
                                    showBartender: $showBartender,
                                    isLoading: $isLoading,
                                    ownedIngs: $ownedIngs,
                                    ownedTools: $ownedTools
                                )
                                .toolbar(.hidden, for: .tabBar)
                            }
                            if currentTab == 2 {
                                CabinetTab(
                                    showBartender: $showBartender,
                                    ownedIngs: $ownedIngs,
                                    ownedTools: $ownedTools,
                                    weatherName: weatherName)
                                    .toolbar(.hidden, for: .tabBar)
                            }
                            if currentTab == 3 {
                                HomeTab(
                                    appJustLaunched: $appJustLaunched,
                                    userName: userName,
                                    weatherName: weatherName,
                                    ownedTools: ownedTools,
                                    ownedIngs: ownedIngs)
                                    .toolbar(.hidden, for: .tabBar)
                            }
                            if currentTab == 4 {
                                NoteTab(
                                    showBartender: $showBartender,
                                    isLoading: $isLoading,
                                    ownedIngs: ownedIngs
                                )
                                    .toolbar(.hidden, for: .tabBar)
                            }
                            if currentTab == 5 {
                                ChallengeTab(
                                    showBartender: $showBartender
                                )
                                    .toolbar(.hidden, for: .tabBar)
                            }
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
                            showBartender = false
                        }
                    }
                
                // Bartender
                BartenderIsland(currentTab: $currentTab, showBartender: $showBartender)
                BartenderBubble(currentTab: $currentTab, showBartender: $showBartender, userName: userName)
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

