//
//  BackGround.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI
import SpriteKit

struct BackGround: View {
    var bgPos: Int = 0
    
    @State var weatherName: String
    
    var body: some View {
        ZStack() {
            let bgSize: CGFloat = 500
            // Background gradient
            let doRain = ["Thunderstorm", "Rain", "Drizzle"].contains(weatherName)
            let doSnow = ["Snow"].contains(weatherName)
            
            Image("city")
                .resizable()
                .frame(width: UIScreen.screenWidth*1.5, height: UIScreen.screenHeight*1.5)
                .offset(y: 100)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.white]), startPoint: .topTrailing, endPoint: .bottomLeading)
                )
                .opacity(0.7)
            
            
            if doRain {
                GeometryReader{_ in
                    SpriteView(scene: RainFall(),options: [.allowsTransparency])
                }
            }
            
            if doSnow {
                GeometryReader{_ in
                    SpriteView(scene: SnowFall(),options: [.allowsTransparency])
                }
            }
            
            // Front Shadow
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .background(Color(red: 0.20, green: 0.20, blue: 0.36).opacity(0.60))
            
            Image("building")
                .resizable()
                .frame(width: bgSize, height: bgSize)
                .offset(x: CGFloat(bgPos-20), y: 300)
                .opacity(0.8)
            
            Rectangle()
                .opacity(0.1)
                .mask(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
        }
    }
}
