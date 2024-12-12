//
//  CabinetTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct CabinetTab: View {
    @Binding var showBartender: Bool
    @Binding var ownedIngs: [String]
    @Binding var ownedTools: [String]
    
    @State private var tabOption: Int = 0
    @State private var pageRefreshed: Bool = true
    var weatherName: String
    
    var audioPlayer: AudioPlayer? = AudioPlayer()
    
    var body: some View {
        VStack {
            Spacer().frame(height: showBartender ? 250 : 150)
            
            TabOptions(
                tabOption: $tabOption,
                options: ["술", "리큐르", "재료", "도구"]
            )
            
            ZStack {
                if tabOption == 0 {
                    CabinetDrinkTab(pageRefreshed: $pageRefreshed)
                        .opacity(pageRefreshed ? 0.9 : 1)
                }
                
                if tabOption == 1{
                    CabinetLiquorTab(pageRefreshed: $pageRefreshed, ownedIngs: $ownedIngs)
                        .opacity(pageRefreshed ? 0.9 : 1)
                }
                
                if tabOption == 2{
                    CabinetIngredientTab(pageRefreshed: $pageRefreshed, ownedIngs: $ownedIngs)
                        .opacity(pageRefreshed ? 0.9 : 1)
                }
                
                if tabOption == 3{
                    CabinetToolsTab(ownedTools: $ownedTools)
                }
                
            } // ZStack
        } // VStack
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .overlay {
            NavigationLink(
                destination: AddView(pageRefreshed: $pageRefreshed, weatherName: weatherName),
                label: {
                    VStack (spacing: 2) {
                        Image(systemName: "barcode.viewfinder")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                        Text("추가하기")
                            .font(.gbRegular10)
                            .foregroundColor(.white)
                    }
            })
            .offset(x: 130, y: UIScreen.screenHeight * -0.4)
            .simultaneousGesture(
                TapGesture().onEnded {
                    audioPlayer?.playSound(fileName: "refresh", fileType: "mp3", volume: 0.15)
                }
            )
        }
    }
}
