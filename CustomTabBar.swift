//
//  CustomTabBar.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var tabSelection: Int
    @Binding var isLoading: Bool
    
    @Namespace private var animationNamespace
    
    // @Environment(\.colorScheme) var colorScheme
    
    let tabBarItems: [(image: String, title: String)] = [
        ("cocktail", "Recipes"),
        ("shelves", "Cabinet"),
        ("home", "Home"),
        ("notes", "Note"),
        ("badge", "Settings")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Capsule()
                    .frame(height: 80)
                    .foregroundColor(Color.mixbyColor1)
                    .shadow(radius: 2)
                    .cornerRadius(90)
                HStack {
                    Spacer()
                    ForEach(0..<5) { index in
                        let player = AudioPlayer()
                        Button {
                            player.playSound(fileName: "click", fileType: "mp3", volume: 0.3)
                            if !isLoading {
                                tabSelection = index + 1
                            }
                        } label: {
                            VStack(spacing: 8) {
                                let iconSize = CGFloat(40)
                                if index+1 == tabSelection {
                                    Image(tabBarItems[index].image+"2")
                                        .resizable()
                                        .frame(width: iconSize, height: iconSize)
                                    Circle()
                                        .frame(height: 6)
                                        .foregroundColor(Color.mixbyColor2)
                                }
                                else {
                                    Image(tabBarItems[index].image)
                                        .resizable()
                                        .frame(width: iconSize, height: iconSize)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer().frame(height: 20)
        }
        .ignoresSafeArea()
    }
}
