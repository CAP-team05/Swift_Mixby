//
//  CabinetDrinkTab.swift
//  mixby2
//
//  Created by Anthony on 12/1/24.
//

import SwiftUI

struct CabinetDrinkTab: View {
    @Binding var pageRefreshed: Bool
    
    @State private var isEmpty: [Bool] = Array(repeating: true, count: 10)
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    private let allBases: [String] = ["위스키", "리큐르", "진", "럼", "테킬라", "보드카", "브랜디", "와인", "기타"]
    
    private let drinkHandler = DrinkHandler()
    
    var body: some View {
        
        ScrollView(.vertical) {
            Spacer().frame(height: 10)
            
            ForEach(0..<allBases.count, id: \.self) { i in
                Section {
                    Spacer().frame(height: 20)
                    titleCard(title: allBases[i])
                    Spacer().frame(height: 10)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        filteredDrinks(for: i, from: drinkHandler.fetchAllDrinks())
                    }
                    
                    if isEmpty[i] {
                        EmptyBox()
                    }
                }
            }
            
            // bottom dummy
            Spacer().frame(height: 200)
        }
        .onChange(of: pageRefreshed) {
            resetIsEmpty()
        }
    }

    // 필터링된 DrinkDTO를 반환하는 함수
    private func filteredDrinks(for index: Int, from drinkDTOArray: [DrinkDTO]) -> some View {
        let filtered = drinkDTOArray.filter { (Int($0.baseCode) ?? 0) / 100 == index+1 }
        
        return ForEach(filtered, id: \.baseCode) { drinkDTO in
            NavigationLink(
                destination: ProductView(drinkDTO: drinkDTO)
                    .navigationBarBackButtonHidden(false)
                    .onDisappear { pageRefreshed.toggle()},
                label: {
                    ProductCard(drinkDTO: drinkDTO)
                        .onAppear {
                            isEmpty[index] = false
                        }
                }
            )
        }
    }

    // `isEmpty` 상태 초기화 함수
    private func resetIsEmpty() {
        isEmpty = Array(repeating: true, count: 10)
    }
}
