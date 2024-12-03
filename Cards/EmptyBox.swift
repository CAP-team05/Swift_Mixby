//
//  EmptyBox.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct EmptyBox: View {
    
    var comment: String = "비어있습니다."
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .opacity(0.1)
                .frame(width: UIScreen.screenWidth-40, height: 50)
                .cornerRadius(30)
            
            Text(comment)
                .font(.gbRegular18)
                .foregroundColor(.white)
                .padding()
        }
    }
}
