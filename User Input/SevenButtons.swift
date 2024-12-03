//
//  SevenButtons.swift
//  mixby2
//
//  Created by Anthony on 12/3/24.
//

import SwiftUI

struct SevenButtons: View {
    @Binding var value: Int
    
    var title: String = "SevenButtons"
    var color: Color = .white
    
    var body: some View {
        VStack {
            Text(title)
                .font(.gbRegular22)
                .foregroundColor(color)
            
            HStack (spacing: 15) {
                ForEach(0..<7) { index in
                    Button {
                        value = index
                    } label: {
                        Circle()
                            .fill(value == index ?
                                  Color.mixbyColor1 : Color.white.opacity(0.6))
                            .frame(width: 40, height: 40)
                    }
                }
            }
        }
        .frame(width: UIScreen.screenWidth - 40)
    }
}
