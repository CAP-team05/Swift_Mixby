//
//  HomeTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct HomeTab: View {
    
    private let userHandler = UserHandler()
    
    var body: some View {
        VStack{
            Text("Home Tab")
            Text("user count: \(userHandler.fetchAllUsers().count)")
        }
    }
}
