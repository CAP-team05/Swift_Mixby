//
//  TutorialBubble.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct TutorialBubble: View {
    @State private var tutorialIndex: Int = 0
    @State private var isQuestion: Bool = false
    @State private var showUserOptions: Bool = false
    
    @State private var userName: String = ""
    @State private var userGender: String = ""
    @State private var userPrefer: String = ""
    
    @Binding var tabSelection: Int
    @Binding var showCustomBar: Bool
    @Binding var showTutorial: Bool
    
    private let userHandler = UserHandler()
    private let tutorialMent: [String] = [
        "...", "흠... 크흠...", "엇? 생각보다 빨리 오셨네요.",
        "기다리고 있었습니다.", "저는 여기 Mixby의 바텐더입니다.",
        "손님께서, 바텐딩을 접하신지 얼마 안됐다고 들어서..",
        "..이것 저것 준비하느라 조금 바빴습니다.", "...",
        "혹시 성함이 어떻게 되시죠?", "...",
        "{userName}님 반갑습니다.", "모자 때문에 그런지 잘 안보는데..",
        "..실례지만 성별이 어떻게 되십니까?", "...",
        "{userGender}분이시군요.", "평소에 술은 좋아하시는지 궁금하네요.",
        "어떤 맛이 가장 취향에 맞으신가요?", "...", "역시 배우신 분인듯 하네요.",
        "이제야 {userName}님에 대해 조금 알게 된것 같습니다.",
        "이어서 저희 바를 소개해드리죠.",
        "화면 하단에 있는 버튼으로 둘러보실 수 있습니다.",
        "먼저 맨 왼쪽 페이지는 레시피가 보관되어 있습니다.",
        "재료를 전부 가지고 계셔야 해금 된다는 점 주의하시길 바랍니다.",
        "그리고 두번째 페이지 입니다.",
        "보유하신 술과 재료를 확인하고 관리하실 수 있습니다.",
        "네번째 페이지에는 '테이스팅 노트'가 정리되어 있습니다.",
        "제조하신 레시피의 맛을 취향대로 맘껏 평가하시면 됩니다.",
        "따라서 보유하신 모든 재료들, 남기신 테이스팅 노트를 바탕으로",
        "제가, 가운데에서 {userName}님을 위해..",
        "매일 새로운 추천을 해드릴겁니다.", "...",
        "서론은 여기까지 하고,",
        "아직 보유하신 재료나 술이 없기 때문에",
        "두번째 탭에서 먼저 등록해주시면 되겠습니다.", "...", "그럼 잘 부탁드립니다."
    ]
    
    private func getComment() -> String {
        var comment = tutorialMent[tutorialIndex]
        comment = comment.replacingOccurrences(of: "{userName}", with: userName)
        comment = comment.replacingOccurrences(of: "{userGender}", with: userGender)
        comment = comment.replacingOccurrences(of: "{userPrefer}", with: userPrefer)
        return comment
    }
    
    private func fetchUserInfo() {
        let userDTO = UserDTO(name: userName, gender: userGender, favoriteTaste: userPrefer, persona: "")
        userHandler.insertUser(user: userDTO)
    }
    
    private func handleUserInput() {
        switch tutorialIndex {
        case 8: showUserOptions = true
        case 12: showUserOptions = true
        case 16: showUserOptions = true
        case 19: showCustomBar = true; tutorialIndex += 1
        case 21: tabSelection = 1; tutorialIndex += 1
        case 23: tabSelection = 2; tutorialIndex += 1
        case 25: tabSelection = 4; tutorialIndex += 1
        case 28: tabSelection = 3; tutorialIndex += 1
        case 36: fetchUserInfo(); showTutorial = false
        default: tutorialIndex += 1
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .opacity(showCustomBar ? 0.1 : 1)
                .mask(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
            
            Text("화면을 클릭하여 대화를 진행하세요")
                .font(.gbRegular16)
                .foregroundColor(.white.opacity(0.5))
//                .offset(y: UIScreen.screenHeight * 0.05)
            
            VStack {
                ZStack {
                    Rectangle()
                        .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))
                        .foregroundColor(Color.white)
                        .opacity(0.2)
                        .cornerRadius(30)
                    
                    if !getComment().isEmpty { // 텍스트가 비어있지 않을 때만 보여줌
                        Text(getComment())
                            .font(.gbRegular22)
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            .frame(width: UIScreen.screenWidth - 60, height: 100)
                            .id(tutorialIndex) // 상태 변화 감지
                    }
                }
                .frame(width: UIScreen.screenWidth-40, height: 100)
                
                if showUserOptions {
                    switch tutorialIndex {
                    case 8:
                        TextField("별명을 입력해주세요", text: $userName)
                            .padding()
                            .frame(width: UIScreen.screenWidth - 40, height: 50)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(40)
                            .onSubmit {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    handleUserInput()
                                    tutorialIndex += 1
                                    showUserOptions = false
                                }
                            }
                    case 12:
                        userOptionButtons(options: ["남성", "여성"], selection: $userGender)
                    case 16:
                        userOptionButtons(options: ["달콤", "상큼", "묵직", "도수"], selection: $userPrefer)
                    default:
                        EmptyView()
                    }
                }
                Spacer()
            }
            .offset(y: -UIScreen.screenHeight * 0.1)
            .frame(height: 400)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) { handleUserInput() }
        }
    }
    
    private func userOptionButtons(options: [String], selection: Binding<String>) -> some View {
        HStack {
            ForEach(options, id: \.self) { option in
                Capsule()
                    .fill(Color.mixbyColor1.opacity(0.5))
                    .overlay(Text(option).font(.gbRegular16).foregroundColor(.white))
                    .onTapGesture {
                        selection.wrappedValue = option
                        handleUserInput()
                        showUserOptions = false
                        tutorialIndex += 1
                    }
            }
        }
        .frame(width: UIScreen.screenWidth - 40, height: 50)
    }
}
