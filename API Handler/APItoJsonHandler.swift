import Foundation
// import SwiftSoup

func decodeToKorean(jsonString: String) -> String {
    return decodeUnicode(jsonString: jsonString)
}

func splitString(str: Substring) -> String {
    let s = String(str).split(separator: " ")[1]
    
    return String(s.split(separator: ",")[0])
}


func getTagFromJson(json: String, tag: String) -> String {
    guard json.split(separator: tag).count > 1 else { return "error" }
    let result = String(json.split(separator: tag)[1])
    
    return String(result.split(separator: "\"")[1])
}

// Unicode 디코딩 함수
func decodeUnicode(jsonString: String) -> String {
    let tempString = jsonString.replacingOccurrences(of: "\\u", with: "\\U")
                               .replacingOccurrences(of: "\"", with: "\\\"")
    let quotedString = "\"\(tempString)\""
    guard let data = quotedString.data(using: .utf8) else { return jsonString }
    let decodedString = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? String
    return decodedString?.replacingOccurrences(of: "\\\"", with: "\"")
                         .replacingOccurrences(of: "\\U", with: "\\u") ?? jsonString
}

func GetJsonFromURL(url: String) -> String {
    guard let url = URL(string: url) else {
        return "Wrong URL" // URL이 잘못되었을 경우 빈 문자열 반환
    }
    
    var result: String = ""
    let semaphore = DispatchSemaphore(value: 0) // 동기화를 위한 세마포어 생성
    
    // URLSession으로 데이터 요청
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data, let jsonString = String(data: data, encoding: .utf8) {
            result = jsonString // JSON 문자열 저장
        }
        semaphore.signal() // 작업 완료를 알림
    }.resume()
    
    semaphore.wait() // 작업이 끝날 때까지 대기
    return decodeToKorean(jsonString: result) // JSON 문자열 반환
}

