//
//  HomeTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct HomeTab: View {
    
    private let userDTO = UserHandler.searchAll()
    
    var body: some View {
        ZStack{
            Text("Home Tab")
            
        }
    }
}
