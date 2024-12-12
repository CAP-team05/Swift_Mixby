//
//  ChallengeHandler.swift
//  mixby2
//
//  Created by Ys on 12/12/24.
//


import Foundation

class ChallengeHandler {
    static let shared = ChallengeHandler()
    var challenges: [ChallengeDTO]

    private init() {
        challenges = [
            ChallengeDTO(id: 0, title: "여정의 시작", description: "앱 실행", isUnlocked: true),
            ChallengeDTO(id: 1, title: "너의 눈동자에 치얼스", description: "달콤한 칵테일 제조", isUnlocked: false),
            ChallengeDTO(id: 2, title: "정말~ 달콤해", description: "달콤한 칵테일 3종 완성", isUnlocked: false),
            ChallengeDTO(id: 3, title: "시작이 반이다", description: "처음 칵테일 제조 완료", isUnlocked: false),
            ChallengeDTO(id: 4, title: "칵테일 마스터", description: "모든 칵테일을 완성", isUnlocked: false),
            ChallengeDTO(id: 5, title: "연금술의 경지", description: "5가지 이상의 재료가 들어가는 칵테일 제조", isUnlocked: false),
            ChallengeDTO(id: 6, title: "흔들어야 제맛", description: "쉐이커를 사용하여 칵테일 제조", isUnlocked: false),
            ChallengeDTO(id: 7, title: "완벽한 여과", description: "스트레이너 사용하여 칵테일 제조", isUnlocked: false),
            ChallengeDTO(id: 8, title: "얼음 없는 세상", description: "얼음이 없는 칵테일 제조", isUnlocked: false),
            ChallengeDTO(id: 9, title: "차가운 한 잔", description: "얼음이 있는 칵테일 제조", isUnlocked: false),
            ChallengeDTO(id: 10, title: "다재다능", description: "모든 술 종류(보드카, 브랜디, 위스키, 진, 럼, 데낄라) 한 병 이상 보유", isUnlocked: false),
            ChallengeDTO(id: 11, title: "리큐르도 술이야", description: "리큐르 1종 보유", isUnlocked: false),
            ChallengeDTO(id: 12, title: "단맛의 유혹", description: "리큐르 3종 이상 보유", isUnlocked: false),
            ChallengeDTO(id: 13, title: "키가 크는 어른", description: "우유가 들어간 칵테일 제조", isUnlocked: false),
            ChallengeDTO(id: 14, title: "크리미 마스터", description: "우유가 들어간 칵테일 3회 이상 제조", isUnlocked: false),
            ChallengeDTO(id: 15, title: "정밀한 한 잔", description: "지거를 이용하여 음료 제작", isUnlocked: false),
            ChallengeDTO(id: 16, title: "버리지 못한 소주 유전자", description: "소주잔을 이용하여 음료 제작", isUnlocked: false),
            ChallengeDTO(id: 17, title: "숟", description: "숟가락을 이용하여 음료 제작", isUnlocked: false),
            ChallengeDTO(id: 18, title: "아카이브의 시작", description: "테이스팅 노트 작성 완료", isUnlocked: true),
            ChallengeDTO(id: 19, title: "노트 수집가", description: "테이스팅 노트 3개 이상 작성 완료", isUnlocked: false),
            ChallengeDTO(id: 20, title: "나만의 바 채우기", description: "술 10개 이상 등록 완료", isUnlocked: false),
            ChallengeDTO(id: 21, title: "추천을 믿어봐", description: "추천한 음료 제작 완료", isUnlocked: false),
            ChallengeDTO(id: 22, title: "추천 알고리즘", description: "추천한 음료 3종 이상 제작 완료", isUnlocked: false),
            ChallengeDTO(id: 23, title: "씁쓸함 한 잔 주시오", description: "도수가 높은 칵테일 제조 완료", isUnlocked: false),
            ChallengeDTO(id: 24, title: "무슨 일이 있었나요?", description: "도수가 높은 칵테일 3종 이상 제조 완료", isUnlocked: false),
            ChallengeDTO(id: 25, title: "탄산의 즐거움", description: "탄산이 들어간 칵테일 제조 완료", isUnlocked: false),
            ChallengeDTO(id: 26, title: "CO2 중독자", description: "탄산이 들어간 칵테일 3종 이상 제조 완료", isUnlocked: false),
            ChallengeDTO(id: 27, title: "레시피 마스터 50", description: "레시피 해금 50개 완료", isUnlocked: false),
            ChallengeDTO(id: 28, title: "레시피 마스터 100", description: "레시피 해금 100개 완료", isUnlocked: false),
            ChallengeDTO(id: 29, title: "레시피 마스터 200", description: "레시피 해금 200개 완료", isUnlocked: false),
            ChallengeDTO(id: 30, title: "레시피 마스터 300", description: "레시피 해금 300개 완료", isUnlocked: false),
            ChallengeDTO(id: 31, title: "레시피 마스터 500", description: "레시피 해금 500개 완료", isUnlocked: false),
            ChallengeDTO(id: 32, title: "열정적인 하루", description: "하루에 2개 이상 칵테일 제조 완료", isUnlocked: false),
            ChallengeDTO(id: 33, title: "위스키 초보", description: "위스키 1종 보유", isUnlocked: false),
            ChallengeDTO(id: 34, title: "위스키 애호가", description: "위스키 3종 이상 보유", isUnlocked: false),
            ChallengeDTO(id: 35, title: "보드카 초보", description: "보드카 1종 보유", isUnlocked: false),
            ChallengeDTO(id: 36, title: "보드카 애호가", description: "보드카 3종 이상 보유", isUnlocked: false),
            ChallengeDTO(id: 37, title: "럼 초보", description: "럼 1종 보유", isUnlocked: false),
            ChallengeDTO(id: 38, title: "럼 애호가", description: "럼 3종 이상 보유", isUnlocked: false),
            ChallengeDTO(id: 39, title: "진 초보", description: "진 1종 보유", isUnlocked: false),
            ChallengeDTO(id: 40, title: "진 애호가", description: "진 3종 이상 보유", isUnlocked: false),
            ChallengeDTO(id: 41, title: "브랜디 초보", description: "브랜디 1종 보유", isUnlocked: false),
            ChallengeDTO(id: 42, title: "브랜디 애호가", description: "브랜디 3종 이상 보유", isUnlocked: false),
            ChallengeDTO(id: 43, title: "데낄라 초보", description: "데낄라 1종 보유", isUnlocked: false),
            ChallengeDTO(id: 44, title: "데낄라 애호가", description: "데낄라 3종 이상 보유", isUnlocked: false),
            ChallengeDTO(id: 45, title: "나만의 한 잔", description: "내 맘에 쏙 드는 음료 제작 완료", isUnlocked: false),
            ChallengeDTO(id: 46, title: "입맛대로", description: "수정된 레시피로 음료 제작 완료", isUnlocked: false),
            ChallengeDTO(id: 47, title: "쓜", description: "술이 2종 이상 들어가는 칵테일 제작 완료", isUnlocked: false)
        ]
    }
    
    func id2title(id: Int) -> String {
        return challenges[id].title
    }
    
    func id2description(id: Int) -> String {
        return challenges[id].description
    }
    
    func id2isUnlocked(id: Int) -> Bool {
        return challenges[id].isUnlocked
    }
    
    func lengthChellengeList() -> Int {
        return challenges.count
    }
    
    func unlockChallenge(id: Int) {
        if let index = challenges.firstIndex(where: { $0.id == id }) {
            challenges[index].unlocked()
            sendLocalNotification(title: challenges[index].title, body: challenges[index].description)
        }
    }
}
