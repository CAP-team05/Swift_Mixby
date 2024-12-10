//
//  UserInputCard.swift
//  mixby2
//
//  Created by Anthony on 12/8/24.
//

import SwiftUI

struct UserBubble: View {
    
    var param: String = "어쩌구"
    var res: String = "저쩌구"
    
    var body: some View {
        HStack {
            Spacer()
            
            ZStack {
                Rectangle()
                    .background(VisualEffectView(effect: UIBlurEffect(style: .light)))
                    .foregroundColor(Color.mixbyColor0.opacity(0.1))
                    .frame(width: UIScreen.screenWidth-160, height: 40)
                    .shadow(color: Color.white.opacity(0.4), radius: 4)
                    .mask(
                        BubbleShape(myMessage: true)
                    )
                
                VStack (spacing: 10) {
                    HStack {
                        Text("\(param)")
                            .font(.gbRegular16)
                            .foregroundColor(.yellow)
                        Text("에 맞는 레시피 추천해줘.")
                            .font(.gbRegular16)
                            .foregroundColor(.white)
                    }
                    
//                    ZStack {
//                        Capsule()
//                            .frame(width: 120, height: 25)
//                            .foregroundColor(Color.mixbyColor1.opacity(0.7))
//                        
//                        Text("\(param) - \(res)")
//                            .font(.gbRegular14)
//                            .foregroundColor(.orange.opacity(0.7))
//                    }
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
