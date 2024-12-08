//
//  TabOptions.swift
//  mixby2
//
//  Created by Anthony on 11/28/24.
//

import SwiftUI

struct TabOptions: View {
    @Binding var tabOption: Int
    
    var options: [String] = ["opt1", "opt2"]
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 40)
                .foregroundColor(.black.opacity(0.1))
            HStack {
                let defaultSize = UIScreen.screenWidth/CGFloat(options.count)-10
                let activeSize = defaultSize + 36
                let deactiveSize = defaultSize - 36/CGFloat(options.count-1)
                
                ForEach(0 ..< options.count, id: \.self) { index in
                    Button(action: {
                        withAnimation (.easeInOut(duration: 0.3)) {
                            tabOption = index
                        }
                    },label: {
                        ZStack {
                            Capsule()
                                .fill(tabOption==index ? Color.mixbyColor1 : Color.mixbyColor2)
                                .opacity(tabOption==index ? 0.8 : 0.2)
                            Text(options[index])
                                .font(.gbRegular16)
                                .foregroundColor(.white)
                        } // ZStack
                        .frame(
                            width: tabOption==index ? activeSize : deactiveSize
                        )
                    }) // Button
                }
            }
        }.frame(width: UIScreen.screenWidth - 10, height: 40)
    }
}
