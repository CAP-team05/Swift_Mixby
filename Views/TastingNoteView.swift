//
//  UnwrittenNoteView.swift
//  mixby2
//
//  Created by Anthony on 12/3/24.
//

import SwiftUI

struct TastingNoteView: View {
    @Environment(\.presentationMode) private var presentationMode : Binding<PresentationMode>
    
    @State var eval: Int = -1
    @State var sweetness: Int = -1
    @State var sourness: Int = -1
    @State var alcohol: Int = -1
    
    var tastingNoteDTO: TastingNoteDTO
    
    var body: some View {
        
        ZStack {
            
            ViewBackground()
            
            Spacer()
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button(action: {
//                            presentationMode.wrappedValue.dismiss()
//                        }, label: {
//                            Image(systemName: "info.circle")
//                                .font(.system(size: 18))
//                                .foregroundColor(.white)
//                        })
//                    }
//                }
            
            VStack {
                Spacer().frame(height: 70)
                
                HStack {
                    let image_url = URL(string: "http://cocktail.mixby.kro.kr:2222/recipe/image="+tastingNoteDTO.english_name)
                    
                    AsyncImage(url: image_url) { result in
                        result.image?
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 200, height: 200)
                    .cornerRadius(50)
                    .shadow(
                        color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                    )
                    Spacer()
                    
                    VStack (spacing: 30) {
                        Text(tastingNoteDTO.english_name)
                            .font(.gbRegular24)
                            .foregroundColor(.white)
                        
                        Text(tastingNoteDTO.korean_name)
                            .font(.gbBold30)
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 20)
                
                HStack {
                    VStack (spacing: 20) {
                        
                        SevenButtons(value: $eval,
                                     title: "종합 평가",
                                     color: .yellow.opacity(0.8))
                        SevenButtons(value: $sweetness,
                                     title: "당도",
                                     color: .white.opacity(0.8))
                        SevenButtons(value: $sourness,
                                     title: "산도",
                                     color: .white.opacity(0.8))
                        SevenButtons(value: $alcohol,
                                     title: "알코올",
                                     color: .white.opacity(0.8))
                        
                        HStack {
                            VStack {
                                Image("less")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("부족")
                                    .font(.gbRegular18)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Image("best")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("최고")
                                    .font(.gbRegular18)
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Image("much")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("과도")
                                    .font(.gbRegular18)
                                    .foregroundColor(.white)
                            }
                        }.frame(width: UIScreen.screenWidth - 20)
                    }
                }
                
                Spacer().frame(height: 30)
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.white.opacity(0.5))
                            Text("취소")
                                .font(.gbRegular18)
                                .foregroundColor(.white)
                        }
                    }
                    
                    Button {
                        let newNote = TastingNoteDTO(
                            code: tastingNoteDTO.code,
                            english_name: tastingNoteDTO.english_name,
                            korean_name: tastingNoteDTO.korean_name,
                            drinkDate: tastingNoteDTO.drinkDate,
                            eval: eval,
                            sweetness: sweetness,
                            sourness: sourness,
                            alcohol: alcohol
                        )
                        TastingNoteHandler.update(note: newNote)
                        print("note updated")
                        UserAPIHandler().sendUserDataToAPI()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(Color.mixbyColor1.opacity(0.5))
                            Text("저장하기")
                                .font(.gbRegular18)
                                .foregroundColor(.white)
                        }
                    }
                }.frame(width: UIScreen.screenWidth - 40, height: 40)
                        
                Spacer()
                
            } // VStack
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        } // ZStack
        .onAppear {
            eval = tastingNoteDTO.eval
            sweetness = tastingNoteDTO.sweetness
            sourness = tastingNoteDTO.sourness
            alcohol = tastingNoteDTO.alcohol
        }
    }
}
