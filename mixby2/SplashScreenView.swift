//
//  SplashScreenView.swift
//  mixby2
//
//  Created by Anthony on 12/3/24.
//

import SwiftUI
import WebKit

struct SplashScreenView: View {
    var body: some View {
        ZStack {
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
            
            // Front Shadow
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .background(Color(red: 0.20, green: 0.20, blue: 0.36).opacity(0.60))
            
            Rectangle()
                .opacity(0.1)
                .mask(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
            
            VStack {
                TransparentGIFView(gifName: "loading")
                    .frame(width: 200, height: 200)
                
                Text("앱 실행 중..")
                    .font(.gbRegular26)
                    .foregroundColor(.white)
                
            }
        }
    }
}
