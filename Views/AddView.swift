//
//  AddView.swift
//  mixby2
//
//  Created by Anthony on 11/29/24.
//

import SwiftUI

struct AddView: View {
    @Binding var pageRefreshed: Bool
    
    @State private var scannedCodes: [String] = [] // 중복 방지를 위한 Set
    
    var weatherName: String
    
    @Environment(\.presentationMode) private var presentationMode : Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            BackGround(weatherName: weatherName)
            VStack (spacing: 20) {
                // Spacer().frame(height: 40)
                
                Text("술병의 바코드를 스캔해주세요!")
                    .font(.gbRegular18)
                    .foregroundColor(.white)
                
                BarcodeScannerView(scannedCodes: $scannedCodes)
                    .frame(width: UIScreen.screenWidth, height: 200)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(40)
                        .opacity(0.1)
                    
                    ScrollView {
                        VStack {
                            Spacer().frame(height: 10)
                            ForEach(scannedCodes, id:\.self) { code in
                                AdditionCard(code: code)
                            }
                        }
                    }
                }
                .frame(
                    width: UIScreen.screenWidth - 40,
                    height: UIScreen.screenHeight/2.5)
                HStack {
                    Button (action : {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        ZStack {
                            Capsule()
                                .foregroundColor(.black.opacity(0.4))
                            Text("취소")
                                .font(.gbRegular16)
                        }.frame(width: UIScreen.screenWidth/2 - 60, height: 50)
                    })
                    
                    Button (action : {
                        for code in scannedCodes{
                            let tempDrink = getDrinkDTOFromApi(barcode: code)
                            let drinks = DrinkHandler.shared.searchAll()
                            let contains = drinks.contains { drink in
                                drink.name == tempDrink.name
                            }
                            if !contains {
                                DrinkHandler.shared.insert(drink: tempDrink)
                                print("추가 완료")
                            }
                            else {
                                print("중복됨")
                            }
                        }
                        pageRefreshed.toggle()
                        generateRecipeDTOsByGetKeywords(doPlus: false, keys: [])
                        presentationMode.wrappedValue.dismiss()
                        
                    }, label: {
                        ZStack {
                            Capsule()
                                .foregroundColor(.white.opacity(0.8))
                            Text("추가하기!")
                                .font(.gbBold16)
                                .foregroundColor(.black)
                        }.frame(width: UIScreen.screenWidth/2 + 20, height: 50)
                    })
                }.frame(width: UIScreen.screenWidth - 40, height: 50)
            } // VStack
        
        } // ZStack
    }
}
