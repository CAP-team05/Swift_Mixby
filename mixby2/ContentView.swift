//
//  ContentView.swift
//  mixby2
//
//  Created by Anthony on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var ownedIngs: [String]
    
    @State var weatherName: String
    @State var showTutorial: Bool
    
    @State private var isLoading: Bool = true
    
    var body: some View {
        ZStack {
            if !isLoading {
                if showTutorial {
                    TutorialView(showTutorial: $showTutorial)
                }
                else {
                    MainContentView(ownedIngs: $ownedIngs, weatherName: weatherName)
                }
            }
        }
        .onAppear {
            isLoading = false
            ChallengeHandler.shared.unlockChallenge(id: 0)
        }
    }
}
