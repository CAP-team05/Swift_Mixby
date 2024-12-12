//
//  TitleCard.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct TitleCard: View {
    var title: String = "Title"
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 0.03, green: 0.04, blue: 0.13))
                .frame(width: 82, height: 38)
                .cornerRadius(18)
            Text(title)
                .font(.gbRegular18)
                .foregroundColor(Color.white)
        }
        .offset(x: -145)
    }
}
