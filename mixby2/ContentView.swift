//
//  ContentView.swift
//  mixby2
//
//  Created by Anthony on 12/3/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var ownedIngs: [String]
    @Binding var lastUpdate: Date
    
    @State var weatherName: String
    @State private var isLoading: Bool = true
    @State private var showTutorial: Bool = true
    
    var body: some View {
        ZStack {
            if !isLoading {
                if showTutorial {
                    TutorialView(showTutorial: $showTutorial)
                }
                else {
                    MainContentView(ownedIngs: $ownedIngs, lastUpdate: $lastUpdate, weatherName: weatherName)
                }
            }
        }
        .onAppear {
            showTutorial = UserHandler.searchAll().isEmpty
            if !showTutorial {
                UserAPIHandler().sendUserDataToAPI()
            }
            print("Content View onAppear, \(UserHandler.searchAll().count)")
            isLoading = false
        }
    }
}
