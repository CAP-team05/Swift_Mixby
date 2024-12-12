//
//  ProductCard.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct ProductCard: View {
    var drinkDTO: DrinkDTO
    @State private var refresh: Bool = false // 이미지 로드 상태를 트리거하는 변수

    var body: some View {
        let url = URL(string: "http://cocktail.mixby.kro.kr:2222/drink/image="+drinkDTO.code)
        
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .background(Color.mixbyColor1)
                .shadow(color: Color.mixbyShadow, radius: 4, y: 4)
                .frame(width: 122, height: 160)
                .cornerRadius(19)
                .offset(y: 20)

            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView() // 로딩 중
                        .frame(width: 122, height: 122)
                        .cornerRadius(100)
                        .offset(y: -35)
                        .foregroundColor(.white)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 122, height: 122)
                        .cornerRadius(100)
                        .shadow(color: Color.mixbyShadow, radius: 4, y: 4)
                        .offset(y: -35)
                case .failure:
                    Image(systemName: "photo") // 실패 시 기본 이미지
                        .resizable()
                        .scaledToFit()
                        .frame(width: 122, height: 122)
                        .cornerRadius(100)
                        .offset(y: -35)
                @unknown default:
                    EmptyView()
                }
            }
            .id(refresh) // 상태 변화에 따라 강제 리렌더링
            
            Text(drinkDTO.name)
                .foregroundColor(Color.yellow)
                .font(.gbRegular16)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .offset(y: 50)
            
            Text(drinkDTO.type)
                .font(.gbRegular14)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .frame(width: 122, height: 200)
                .offset(y: 85)
        }
        .onAppear {
            // 강제 리렌더링 트리거
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                refresh.toggle()
            }
        }
    }
}
