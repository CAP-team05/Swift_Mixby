//
//  HomeTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct HomeTab: View {
    
    var body: some View {
        ZStack {
            VStack {
                
                Text(String(describing: UserHandler.searchAll().last?.persona))
                    .font(.gbRegular20)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(width: UIScreen.screenWidth - 40)
    }
}
