//
//  SplashScreenView.swift
//  mixby2
//
//  Created by Anthony on 12/3/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Image(systemName: "circle.dotted")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                Text("로딩 중...")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}
