//
//  ColorManager.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

extension Color {
    static let mixbyColor0 = Color(red: 0.33, green: 0.35, blue: 0.9)
    static let mixbyColor1 = Color(red: 0.11, green: 0.11, blue: 0.22)
    static let mixbyColor2 = Color(red: 0.33, green: 0.35, blue: 0.49)
    
    static let mixbyShadow = Color(red: 0, green: 0, blue: 0, opacity: 0.25)
    
    static func customTabBarColor(forScheme scheme: ColorScheme) -> Color {
            switch scheme {
            case .light:
                return mixbyColor0 // 라이트 모드 색상
            case .dark:
                return mixbyColor0 // 다크 모드 색상
            @unknown default:
                return mixbyColor0 // 기본 색상
            }
        }
}
