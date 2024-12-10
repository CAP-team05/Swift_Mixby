//
//  UserInputCard.swift
//  mixby2
//
//  Created by Anthony on 12/8/24.
//

import SwiftUI

struct OptionBubble: View {
    
    var param: String = "어쩌구"
    
    var body: some View {
        HStack {
            Spacer()
            
            ZStack {
                Rectangle()
                    .background(VisualEffectView(effect: UIBlurEffect(style: .light)))
                    .foregroundColor(Color.mixbyColor0.opacity(0.1))
                    .frame(width: 80, height: 40)
                    .shadow(color: Color.white.opacity(0.4), radius: 4)
                    .mask(
                        BubbleShape(myMessage: true)
                    )
                
                HStack {
                    Text("\(param) ")
                        .font(.gbRegular16)
                        .foregroundColor(.yellow)
                }
            }
            Spacer().frame(width: 10)
        }
        .frame(height: 45)
    }
}


#Preview {
    ZStack {
        Rectangle()
        UserBubble()
    }
}
