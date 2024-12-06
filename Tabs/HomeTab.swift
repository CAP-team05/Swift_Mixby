//
//  HomeTab.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct HomeTab: View {
    
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack{
            VStack {
                if locationManager.latitude == 0.0 && locationManager.longitude == 0.0 {
                    Text("위치 정보를 가져오는 중...")
                        .padding()
                } else {
                    Text(getWeather(
                        lat: locationManager.latitude,
                        long: locationManager.longitude)
                    )
                }
            }
            .padding()
            
            Text("Note count: \(String(describing: UserHandler.searchAll().last?.persona))")
                .font(.gbRegular20)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(width: UIScreen.screenWidth - 40)
    }
}
