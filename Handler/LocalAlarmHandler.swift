//
//  LocalAlarm.swift
//  mixby2
//
//  Created by Ys on 12/12/24.
//

import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    // 포그라운드 상태에서 알림 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge]) // 알림 표시
    }
}

func sendLocalNotification(title: String, body: String) {
    // 알림 콘텐츠 생성
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.badge = NSNumber(value: 1)
    
    // 알림 트리거 설정 (5초 뒤 전송)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    
    // 요청 생성
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    // 알림 센터에 요청 추가
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("알림 전송 실패: \(error.localizedDescription)")
        } else {
            print("알림 전송 성공: \(body)")
        }
    }
}
