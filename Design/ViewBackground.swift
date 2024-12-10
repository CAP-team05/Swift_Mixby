//
//  BackGround.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI
import SpriteKit

struct ViewBackground: View {
    var bgPos: Int = 0
    var doRain: Bool = true
    
    var body: some View {
        ZStack() {
            // let bgSize: CGFloat = 500
            // Background gradient
            
            
            Image("city")
                .resizable()
                .frame(width: UIScreen.screenWidth*1.5, height: UIScreen.screenHeight*1.5)
                .offset(y: 150)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.white]), startPoint: .topTrailing, endPoint: .bottomLeading)
                )
                .opacity(0.7)
            
            // Front Shadow
            Rectangle()
                .foregroundColor(Color.mixbyColor1)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .background(VisualEffectView(effect: UIBlurEffect(style: .light)))
                .opacity(0.5)
                .ignoresSafeArea()
            
            // titleWithDivider(title: "Mixby")
        }
        .mask {
            Rectangle()
                .frame(width: UIScreen.screenWidth)
        }
    }
}
