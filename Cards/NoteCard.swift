//
//  NoteCard.swift
//  mixby2
//
//  Created by Anthony on 11/28/24.
//

import SwiftUI

struct NoteCard: View {
    
    var noteDTO: TastingNoteDTO
    
    var body: some View {
        ZStack{
            Image("page")
                .resizable()
                .frame(width: 350, height: 105)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                )
            
            let image_url = URL(string: "http://cocktail.mixby.kro.kr:2222/recipe/image="+noteDTO.english_name)
            
            AsyncImage(url: image_url) { result in
                result.image?
                    .resizable()
                    .scaledToFill()
            }
                .frame(width: 106, height: 106)
                .cornerRadius(30)
                .offset(x: -125)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                )
            
            Text(noteDTO.korean_name)
                .font(.gbBold16)
                .foregroundColor(Color.black)
                .frame(width: 200, alignment: .leading)
                .offset(x: 45, y: -30)
            
            Text(noteDTO.drinkDate)
                .font(.gbRegular14)
                .foregroundColor(Color.mixbyColor0)
                .frame(width: 200, alignment: .trailing)
                .offset(x: 45, y: -30)
            
            Text(TastingNoteDTO.toEval(n: noteDTO.eval))
                .font(.gbRegular16)
                .foregroundColor(Color.black.opacity(0.7))
                .frame(width: 200, alignment: .leading)
                .offset(x: 45, y: 2)
        }
        .frame(width: 360)
    }
}
