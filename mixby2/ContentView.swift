//
//  ContentView.swift
//  mixby2
//
//  Created by Anthony on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isLoading: Bool = true
    @State private var showTutorial: Bool = true
    
    private let userHandler = UserHandler()
    
    var body: some View {
        ZStack {
            if !isLoading {
                if showTutorial {
                    TutorialView(showTutorial: $showTutorial)
                }
                else {
                    MainContentView()
                }
            }
        }
        .onAppear {
            showTutorial = userHandler.fetchAllUsers().isEmpty
            print("Content View onAppear")
            isLoading = false
        }
    }
}
