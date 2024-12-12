//
//  CabinetDrinkTab.swift
//  mixby2
//
//  Created by Anthony on 12/1/24.
//
import SwiftUI

struct CabinetDrinkTab: View {
    @Binding var pageRefreshed: Bool
    @State private var refreshImages: Bool = false // 이미지 로딩 상태를 강제로 트리거하는 변수
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    private let allBases: [String] = ["위스키", "리큐르", "진", "럼", "테킬라", "보드카", "브랜디", "와인", "기타"]
    
    private let drinkHandler = DrinkHandler()
    
    var body: some View {
        ScrollView(.vertical) {
            Spacer().frame(height: 10)
            
            let allDrinksDTO = DrinkHandler.searchAll()
            ForEach(0..<allBases.count, id: \.self) { index in
                
                titleCard(title: allBases[index])
                
                LazyVGrid(columns: columns, spacing: 20) {
                    filteredDrinks(for: index, from: allDrinksDTO)
                }
                
                let isEmpty: Bool = allDrinksDTO.filter { (Int($0.baseCode) ?? 0) / 100 == index + 1 }.isEmpty
                
                if isEmpty {
                    EmptyBox()
                }
                
                Spacer().frame(height: 20)
            }
            
            // Bottom dummy spacing
            Spacer().frame(height: 200)
        }
        .onChange(of: pageRefreshed) { _, _ in
            refreshImages.toggle() // 이미지 상태 강제 새로고침
        }
    }
    
    // 필터링된 DrinkDTO를 반환하는 함수
    private func filteredDrinks(for index: Int, from drinkDTOArray: [DrinkDTO]) -> some View {
        let filtered: [DrinkDTO] = drinkDTOArray.filter { (Int($0.baseCode) ?? 0) / 100 == index + 1 }
        
        return ForEach(filtered.indices, id: \.self) { idx in
            let drinkDTO = filtered[idx]
            NavigationLink(
                destination: ProductView(drinkDTO: drinkDTO)
                    .navigationBarBackButtonHidden(false)
                    .onDisappear { pageRefreshed.toggle() },
                label: {
                    ProductCard(drinkDTO: drinkDTO)
                }
            )
        }
    }
}
