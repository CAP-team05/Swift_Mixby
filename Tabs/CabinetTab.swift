//
//  CabinetTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct CabinetTab: View {
    @Binding var ownedIngs: [String]
    
    @State private var tabOption: Int = 0
    @State private var pageRefreshed: Bool = true
    
    var body: some View {
        
        VStack {
            ZStack {
                // title dummy
                Rectangle()
                    .frame(height: 280)
                    .opacity(0.1)
                
                NavigationLink(
                    destination: AddView(pageRefreshed: $pageRefreshed),
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
                .offset(x: 130, y: -30)
            }
            
            TabOptions(
                tabOption: $tabOption,
                options: ["술", "리큐르", "재료"]
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
                
            } // ZStack
            .frame(height: UIScreen.screenHeight-300)
        } // VStack
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
    }
}
