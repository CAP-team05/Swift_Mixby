//
//  BartenderIsland.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct BartenderIsland: View {
    @Binding var currentTab: Int
    @Binding var showBartender: Bool
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer().frame(height: 15)
                ZStack {
                    // Dynamic Island
                    
                    Rectangle()
                        .fill(Color.black)
                        .cornerRadius(22)
                        .frame(
                            width: 128,
                            height: 128)
                        .offset(y: 0)
                    
                    
                    TransparentGIFView(gifName: "faceAnimation")
                        .frame(
                            width: 80,
                            height: 80)
                        .offset(y: 5)
                        .opacity(1)
                }
                .frame(width: 128, height: 128)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                if currentTab != 3 {
                    showBartender.toggle()
                }
            }
        }
    }
}
