//
//  BartenderIsland.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct BartenderIsland: View {
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
                            width: showBartender ? 128 : 125,
                            height: showBartender ? 128 : 36)
                        .offset(y: showBartender ? 0 : -46)
                    
                    
                    TransparentGIFView(gifName: "faceAnimation")
                        .frame(
                            width: showBartender ? 80 : 20,
                            height: showBartender ? 80 : 20)
                        .offset(y: showBartender ? 5 : -48)
                        .opacity(showBartender ? 1 : 0)
                }
                .frame(width: 128, height: 128)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}
