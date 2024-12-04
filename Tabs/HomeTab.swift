//
//  HomeTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct HomeTab: View {
    
    var body: some View {
        VStack{
            Text("Home Tab")
            Text("user count: \(UserHandler.searchAll().count)")
            Text("Note count: \(String(describing: UserHandler.searchAll().last?.persona))")
        }
    }
}
