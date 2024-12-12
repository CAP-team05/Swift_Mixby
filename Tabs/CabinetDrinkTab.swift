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
    
    var body: some View {
        ScrollView(.vertical) {
            Spacer().frame(height: 10)
            
            let allDrinksDTO = DrinkHandler.shared.searchAll()
            if allDrinksDTO.count >= 10 { let _ = ChallengeHandler.shared.unlockChallenge(id: 20) }
            ForEach(0..<allBases.count, id: \.self) { index in
                
                TitleCard(title: allBases[index])
                
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
            .onAppear {
                if filtered.count >= 1 && index == 0 { ChallengeHandler.shared.unlockChallenge(id: 33) } // 위스키
                if filtered.count >= 3 && index == 0 { ChallengeHandler.shared.unlockChallenge(id: 34) }
                // if filtered.count >= 1 && index == 1 { ChallengeHandler.shared.unlockChallenge(id: 33) } // 리큐르
                // if filtered.count >= 3 && index == 1 { ChallengeHandler.shared.unlockChallenge(id: 34) }
                if filtered.count >= 1 && index == 2 { ChallengeHandler.shared.unlockChallenge(id: 39) } // 진
                if filtered.count >= 3 && index == 2 { ChallengeHandler.shared.unlockChallenge(id: 40) }
                if filtered.count >= 1 && index == 3 { ChallengeHandler.shared.unlockChallenge(id: 37) } // 럼
                if filtered.count >= 3 && index == 3 { ChallengeHandler.shared.unlockChallenge(id: 38) }
                if filtered.count >= 1 && index == 4 { ChallengeHandler.shared.unlockChallenge(id: 43) } // 테킬라
                if filtered.count >= 3 && index == 4 { ChallengeHandler.shared.unlockChallenge(id: 44) }
                if filtered.count >= 1 && index == 5 { ChallengeHandler.shared.unlockChallenge(id: 35) } // 보드카
                if filtered.count >= 3 && index == 5 { ChallengeHandler.shared.unlockChallenge(id: 36) }
                if filtered.count >= 1 && index == 6 { ChallengeHandler.shared.unlockChallenge(id: 41) } // 브랜디
                if filtered.count >= 3 && index == 6 { ChallengeHandler.shared.unlockChallenge(id: 42) }
            }
        }
    }
}
