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
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView(.vertical) {
            Spacer().frame(height: 10)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<easyTools.count, id: \.self) { index in
                    ToolCard(
                        ownedTools: $ownedTools,
                        name: easyTools[index].name,
                        amount: easyTools[index].amount,
                        isOwned: ownedTools.contains(easyTools[index].name)
                    )
                }
            }
            .frame(width: UIScreen.screenWidth - 20)
            
            // bottom dummy
            Spacer().frame(height: 200)
        }
    }
}
