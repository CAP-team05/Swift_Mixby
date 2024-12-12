//
//  TimeHandler.swift
//  mixby2
//
//  Created by Ys on 12/4/24.
//

import Foundation

class TimeHandler {
    // 현재 월을 반환하는 메서드
    static func getCurrentMonth() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM"
        let _str = dateFormatter.string(from: Date())
        let _int = Int(_str)!
        return _int
    }
    
    // 현재 시간을 반환하는 메서드
    static func getCurrentHour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "HH"  // 'HH'는 시간을 24시간 형식으로 표시합니다 (00~23)
        let _str = dateFormatter.string(from: Date())
        let _time = Int(_str)!
        if (12 <= _time && _time < 18 ) {
            return "낮"
        } else if (18 <= _time && _time < 21 ) {
            return "저녁"
        } else if (21 <= _time || _time < 6) {
            return "밤"
        } else {
            return "아침"
        }
        
        return dateFormatter.string(from: Date())
    }
}
