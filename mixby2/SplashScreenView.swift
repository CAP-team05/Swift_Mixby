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
        let loadingTexts = [
            "마티니 글래스 말리는 중..",
            "지거 닦는 중..",
            "창 밖으로 날씨 확인하는 중..",
            "냉장고에서 재료 찾는 중..",
            "레몬 껍질 벗기는 중..",
            "토치 건전지 교체 중..",
            "수염 만지작 거리는 중..",
            "레시피 골똘히 생각하는 중.."
        ]
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
                
                Text(loadingTexts[Int.random(in: 0..<loadingTexts.count)])
                    .font(.gbRegular26)
                    .foregroundColor(.white)
                
            }
        }
    }
}
