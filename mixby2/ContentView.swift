//
//  ContentView.swift
//  mixby2
//
//  Created by Anthony on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showTutorial: Bool = true
    @State var isLoading: Bool = true
    
    
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
            let user = UserHandler.searchAll()
            showTutorial = (user.count == 0)
            isLoading = false
        }
    }
}
