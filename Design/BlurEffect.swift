//
//  BlurEffect.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI
import UIKit

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct GradientMaskView: View {
    var body: some View {
        Rectangle()
            .mask(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(UIColor.black.withAlphaComponent(0)), // 투명 검정
                        Color(UIColor.black.withAlphaComponent(0.8)) // 반투명 검정
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .offset(y: UIScreen.main.bounds.height / 3 * 2)
            .edgesIgnoringSafeArea(.all)
    }
}
