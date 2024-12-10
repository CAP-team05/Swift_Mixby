//
//  Feelings.swift
//  mixby2
//
//  Created by Anthony on 12/10/24.
//

import SwiftUI

struct Schedules: View {
    var param: String = "바쁨"
    var body: some View {
        ZStack {
            Rectangle()
                .background(VisualEffectView(effect: UIBlurEffect(style: .light)))
                .foregroundColor(Color.mixbyColor2.opacity(0.2))
                .cornerRadius(50)
            HStack {
                Text(getImoji(param: param)+param)
                    .font(.gbRegular14)
                //                Text(param)
                //                    .font(.gbRegular14)
                //                    .foregroundColor(.white)
            }
        }
        .frame(height: 40)
    }
}
