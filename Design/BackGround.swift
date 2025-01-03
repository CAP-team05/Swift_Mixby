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
    
    // SpriteKit 장면을 한 번만 초기화
    private let rainScene = RainFall()
    private let snowScene = SnowFall()
    
    var body: some View {
        ZStack {
            let bgSize: CGFloat = 500
            let doRain = ["천둥", "비", "이슬비"].contains(weatherName)
            let doSnow = ["눈"].contains(weatherName)
            
            Image("city")
                .resizable()
                .frame(width: UIScreen.screenWidth * 1.5, height: UIScreen.screenHeight * 1.5)
                .offset(y: 100)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.white]), startPoint: .topTrailing, endPoint: .bottomLeading)
                )
                .opacity(0.7)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .background(Color(red: 0.20, green: 0.20, blue: 0.36).opacity(0.60))
            
            if doRain {
                SpriteView(scene: rainScene, options: [.allowsTransparency])
                    .ignoresSafeArea()
            }
            
            if doSnow {
                SpriteView(scene: snowScene, options: [.allowsTransparency])
                    .ignoresSafeArea()
            }
            
            Image("building")
                .resizable()
                .frame(width: bgSize, height: bgSize)
                .offset(x: CGFloat(bgPos - 20), y: 300)
                .opacity(0.8)
            
            Rectangle()
                .opacity(0.1)
                .mask(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
        }
        .onAppear {
            // Scene 크기 설정 (필요 시)
            let screenSize = UIScreen.main.bounds.size
            rainScene.size = screenSize
            snowScene.size = screenSize
        }
    }
}
