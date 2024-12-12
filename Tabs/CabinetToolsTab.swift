//
//  CabinetToolsTab.swift
//  mixby2
//
//  Created by Anthony on 12/6/24.
//

import SwiftUI

struct CabinetToolsTab: View {
    @Binding var ownedTools: [String]
    
    @State var easyTools: [(name: String, amount: Int, have: Bool)] = [
        (name: "숟가락", amount: 10, have: true),
        (name: "소주잔", amount: 50, have: true),
        (name: "종이컵", amount: 100, have: true)
    ]
    @State var hardTools: [(name: String, description: String, have: Bool)] = [
        (name: "지거", description: "세밀한 용량 측정", have: true),
        (name: "쉐이커", description: "완벽한 재료 섞기", have: true),
        (name: "스트레이너", description: "큰 입자 거르기", have: true)
    ]
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(.vertical) {
            Spacer().frame(height: 10)
            TitleCard(title: "일상")
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<easyTools.count, id: \.self) { index in
                    EasyToolCard(
                        ownedTools: $ownedTools,
                        name: easyTools[index].name,
                        amount: easyTools[index].amount,
                        isOwned: ownedTools.contains(easyTools[index].name)
                    )
                }
            }
            .frame(width: UIScreen.screenWidth - 20)
            
            Spacer().frame(height: 10)
            TitleCard(title: "전문")
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<hardTools.count, id: \.self) { index in
                    HardToolCard(
                        ownedTools: $ownedTools,
                        name: hardTools[index].name,
                        description: hardTools[index].description,
                        isOwned: ownedTools.contains(hardTools[index].name)
                    )
                }
            }
            .frame(width: UIScreen.screenWidth - 20)
            
            // bottom dummy
            Spacer().frame(height: 200)
        }
    }
}
