//
//  Recommands.swift
//  mixby2
//
//  Created by Anthony on 12/8/24.
//

import SwiftUI

struct Recommands: View {
    var param: String = ""
    var body: some View {
        ZStack {
            Rectangle()
                .background(VisualEffectView(effect: UIBlurEffect(style: .light)))
                .foregroundColor(Color.white.opacity(0.2))
                .cornerRadius(50)
            HStack {
                Text(getImoji(param: param)+param)
                    .font(.gbRegular14)
                    .foregroundColor(.white)
//                Text(param)
//                    .font(.gbRegular14)
//                    .foregroundColor(.white)
            }
        }
        .frame(height: 40)
    }
}
