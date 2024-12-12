//
//  ChatScrollView.swift
//  mixby2
//
//  Created by Anthony on 12/9/24.
//

import SwiftUI
import Foundation

func getImoji(param: String) -> String {
    let imoji: String = switch param {
    case "계절": "❄️"
    case "시간": "⏰"
    case "날씨": "☀️"
    case "기분": "❤️"
    case "일정": "🗓️"
    case "행복": "😁"
    case "피곤": "😞"
    case "화남": "😡"
    case "바쁨": "🫠"
    case "한가": "😴"
    case "여행": "😎"
    default: "↩️" // 뒤로
    }
    return imoji
}

struct ChatMessage: Codable, Identifiable {
    let id: Int
    let type: String
    let param: String
    let reason: String
    let tag: String
    let recipe: RecipeDTO?
}

struct ChatScrollView: View {
    @AppStorage("messages") private var messagesData: String = "[]"
    
    @Binding var appJustLaunched: Bool
    
    @State private var messages: [ChatMessage] = []
    
    @State private var visibleMessages: Set<Int> = []
    @State private var messageID: Int = 0
    
    @State private var clickedButton: String = "None"
    @State private var canClickButton: Bool = true
    @State private var isRefreshing: Bool = false
    @State private var showError: Bool = false
    @State private var isRecipeEmpty: Bool = false
    @State private var inputMode: Int = 0
    
    @AppStorage("hello") private var hello: String = ""
    @AppStorage("question") private var question: String = ""
    
    @State var userName: String
    @State var weatherName: String
    
    @State private var scrollPosition: String? = nil // 스크롤 위치를 관리하는 상태 변수
    
    private let buttonOptions = ["계절", "시간", "날씨", "기분", "일정"]
    private let feelingOptions = ["행복", "피곤", "화남", "뒤로"]
    private let scheduleOptions = ["바쁨", "한가", "여행", "뒤로"]
    
    var ownedTools: [String]
    var ownedIngs: [String]
    
    var audioPlayer: AudioPlayer? = AudioPlayer()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.1)
                .cornerRadius(40)
            
            Spacer()
            .alert(isPresented: $showError) {
                Alert(
                    title: Text("조금만 기다려주세요."),
                    message: Text("아직 로딩이 완료되지 않았습니다."),
                    dismissButton: .default(Text("확인"), action: {
                        showError = false // 상태 변수 리셋
                    })
                )
            }
            .opacity(0.5)
            
            
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 10) {
                            Spacer().frame(height: 20).id("TopDummy")
                            welcomeMessage
                            messageList
                            Spacer().frame(height: 170).id("BottomDummy")
                        }
                    }
                    .refreshable {
                        resetChat()
                        setRandomMessage()
                    }
                    .mask(Rectangle().cornerRadius(40))
                    .shadow(color: Color.mixbyShadow, radius: 4, x: 0, y: 0)
                    .onChange(of: messages.count) { _, _ in
                        scrollToBottom(proxy: proxy)
                    }
                    .overlay {
                        ZStack {
                            Capsule()
                                .foregroundColor(Color.white.opacity(0.5))
                            Image(systemName: "chevron.up")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                        .frame(width: 40, height: 40)
                        .opacity(0.5)
                        .offset(x: 110, y: -400)
                        .onTapGesture {
                            scrollToTop(proxy: proxy)
                        }
                        ZStack {
                            Capsule()
                                .foregroundColor(Color.white.opacity(0.5))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10))
                                .foregroundColor(.white)
                        }
                        .frame(width: 40, height: 40)
                        .opacity(0.5)
                        .offset(x: 155, y: -400)
                        .onTapGesture {
                            scrollToBottom(proxy: proxy)
                        }
                    }
                }
            }
            .overlay {
                if isRefreshing {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.black.opacity(0.5))
                            .cornerRadius(40)
                        VStack {
                            TransparentGIFView(gifName: "loading")
                                .frame(width: 100, height: 100)
                                .offset(y: -100)
                            
                            Text("로딩 중..")
                                .font(.gbRegular20)
                                .foregroundColor(.white)
                                .offset(y: -100)
                        }
                    }
                    .ignoresSafeArea()
                }
            }
            inputSection
        }
        .onAppear {
            Task {
                print("main page appeared")
                
                canClickButton = true
                loadMessages()
                inputMode = 0
                
                if appJustLaunched {
//                    let recipeDTOs = RecipeHandler.searchAll()
//                    isRecipeEmpty = recipeDTOs.isEmpty
                    resetChat()
                    setRandomMessage()
                    appJustLaunched = false
                }
            }
        }
    }
    
    private var welcomeMessage: some View {
        if isRecipeEmpty {
            return BartenderChatBubble(firstLine: "\(userName)님, \(hello)", secondLine: "추천 가능한 레시피가 없네요.")
        } else {
            return BartenderChatBubble(firstLine: "\(userName)님, \(hello)", secondLine: question)
        }
    }
    
    private var messageList: some View {
        ForEach(messages) { message in
            messageView(for: message)
        }
    }
    
    private var inputSection: some View {
        VStack {
            Spacer()
            HStack(spacing: 10) {
                Spacer().frame(width: 10)
                inputButtons
                Spacer().frame(width: 10)
            }
            Spacer().frame(height: 130)
        }
    }
    
    @ViewBuilder
    private var inputButtons: some View {
        switch inputMode {
        case 0: createButtons(from: buttonOptions, action: handleDefaultInput)
        case 1: createButtons(from: feelingOptions, action: handleFeelingInput)
        case 2: createButtons(from: scheduleOptions, action: handleScheduleInput)
        default: createButtons(from: buttonOptions, action: handleDefaultInput)
        }
    }
    
    private func createButtons(from options: [String], action: @escaping (Int) -> Void) -> some View {
        ForEach(options.indices, id: \.self) { index in
            Button(action: {
                action(index)
            }) {
                Recommands(param: options[index])
            }
        }
    }
    
    
    private func handleDefaultInput(_ index: Int) {
        print("handlerDefaultInput, index: \(index)")
        clickedButton = buttonOptions[index]
        
        print(canClickButton)
        
        if isRefreshing {
            showError = true
        } else {
            if canClickButton && !isRecipeEmpty {
                canClickButton = false
                
                addMessage(type: "User", param: buttonOptions[index], recipe: nil)
                
                if index >= 3 {
                    audioPlayer?.playSound(fileName: "drop", fileType: "mp3", volume: 0.15)
                    withAnimation { inputMode = index - 2 }
                    addMessage(type: "Bartender", param: buttonOptions[index], recipe: nil)
                } else {
                    audioPlayer?.playSound(fileName: "ice", fileType: "mp3", volume: 0.05)
                    
                    let ind: Int = index / 3
                    performRefresh(id: ind) {
                        // performRefresh 완료 후 실행
                        let recommendDTOs = RecommendHandler.shared.searchAll()
                        let cnt = recommendDTOs.count
                        print("cnt: \(cnt)")
                        
                        if index < cnt {
                            addMessage(
                                type: "Recommand",
                                param: buttonOptions[index],
                                recipe: getRecipeDTObyName(name: recommendDTOs[index].name),
                                reason: recommendDTOs[index].reason,
                                tag: recommendDTOs[index].tag
                            )
                        }
                    }
                }
                canClickButton = true
            }
        }
    }
    
    private func handleFeelingInput(_ index: Int) {
        print("handleFeelingInput, index: \(index)")
        
        if index == 3 {
            audioPlayer?.playSound(fileName: "drop", fileType: "mp3", volume: 0.15)
            withAnimation { inputMode = 0 }
        } else {
            audioPlayer?.playSound(fileName: "ice", fileType: "mp3", volume: 0.05)
            
            addMessage(type: "Option", param: getImoji(param: feelingOptions[index]) + feelingOptions[index], recipe: nil)
            
            let ind: Int = index / 3
            performRefresh(id: ind) {
                
                let recommendDTOs = RecommendHandler.shared.searchAll()
                let cnt = recommendDTOs.count
                
                if index < cnt {
                    addMessage(
                        type: "Recommand",
                        param: buttonOptions[index],
                        recipe: getRecipeDTObyName(name: recommendDTOs[index].name),
                        reason: recommendDTOs[index].reason,
                        tag: recommendDTOs[index].tag
                    )
                }
            }
        }
    }
    
    private func handleScheduleInput(_ index: Int) {
        print("handleScheduleInput, index: \(index)")
        
        if index == 3 {
            audioPlayer?.playSound(fileName: "drop", fileType: "mp3", volume: 0.15)
            withAnimation { inputMode = 0 }
        } else {
            audioPlayer?.playSound(fileName: "ice", fileType: "mp3", volume: 0.05)
            
            addMessage(type: "Option", param: getImoji(param: scheduleOptions[index]) + scheduleOptions[index], recipe: nil)
            
            let ind: Int = index / 3
            performRefresh(id: ind) {
                let recommendDTOs = RecommendHandler.shared.searchAll()
                let cnt = recommendDTOs.count
                
                if index-6 < cnt {
                    addMessage(
                        type: "Recommand",
                        param: buttonOptions[index],
                        recipe: getRecipeDTObyName(name: recommendDTOs[index].name),
                        reason: recommendDTOs[index].reason,
                        tag: recommendDTOs[index].tag
                    )
                }
            }
        }
    }
    
    func performRefresh(id: Int, completion: @escaping () -> Void) {
        isRefreshing = true
        DispatchQueue.global().async {
            RecommendAPIHandler.shared.refreshDefaultRecommendDTOs(weather: weatherName, id: id) {
                print("recommends refreshed completly")
                DispatchQueue.main.async {
                    isRefreshing = false
                    completion()
                }
            }
        }
    }
    
    private func resetChat() {
        // 채팅 내역 삭제
        messages.removeAll()
        saveMessages()
        
        // 화면 상태 초기화
        visibleMessages.removeAll()
        messageID = 0
        inputMode = 0
        canClickButton = true
        
        print("Chat reset successfully!")
    }
    
    private func setRandomMessage() {
        let randomHello = [
            "환영합니다.",
            "어서오세요.",
            "안녕하세요.",
            "반갑습니다.",
            "기다리고 있었습니다."
        ]
        
        let randomQuestions = [
            "어떤 술을 추천드릴까요?",
            "어떤 술을 드시고 싶으신가요?",
            "오늘은 어떤걸 원하시나요?"
        ]
        
        hello = randomHello[Int.random(in: 0..<randomHello.count)]
        question = randomQuestions[Int.random(in: 0..<randomQuestions.count)]
    }
    
    private func addMessage(type: String, param: String, recipe: RecipeDTO?, reason: String = "", tag: String = "") {
        // 고유 ID 생성
        messageID += 1
        
        // 새로운 메시지 생성
        let newMessage = ChatMessage(id: messageID, type: type,  param: param, reason: reason, tag: tag, recipe: recipe)
        
        // 메시지를 추가하기 전에 중복된 ID가 없는지 확인
        if !messages.contains(where: { $0.id == newMessage.id }) {
            messages.append(newMessage)
            saveMessages()
        }
    }
    
    @ViewBuilder
    private func messageView(for message: ChatMessage) -> some View {
        ZStack {
            switch message.type {
            case "User":
                UserBubble(param: message.param, res: "res")
                
            case "Option":
                OptionBubble(param: message.param)
                
            case "Bartender":
                BartenderChatBubble(
                    firstLine: getPromptTitle(for: message.param),
                    secondLine: "아래 옵션을 선택해주세요."
                )
                
            case "Recommand":
                let recipeDTO = message.recipe!
                NavigationLink {
                    RecipeView(recipeDTO: recipeDTO, ownedTools: ownedTools, ownedIngs: ownedIngs)
                } label: {
                    RecommendBubble(
                        recipeDTO: recipeDTO, reason: message.reason, tag: message.tag
                    )
                }
                
            default:
                EmptyView()
            }
        }
        .id(message.id)
        .opacity(visibleMessages.contains(message.id) ? 1 : 0)
        .onAppear {
            withAnimation {
                _ = visibleMessages.insert(message.id)
            }
            canClickButton = true
        }
    }
    
    private func getPromptTitle(for param: String) -> String {
        param == "기분" ? "어떤 기분이신가요?" : "어떤 일정을 보내셨나요?"
    }
    
    private func scrollToTop(proxy: ScrollViewProxy) {
        withAnimation(Animation.interpolatingSpring(stiffness: 50, damping: 5)) {
            proxy.scrollTo("TopDummy", anchor: .top)
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation(Animation.interpolatingSpring(stiffness: 50, damping: 5)) {
            proxy.scrollTo("BottomDummy", anchor: .bottom)
        }
    }
    
    private func loadMessages() {
        guard let data = messagesData.data(using: .utf8) else {
            messages = []
            return
        }
        do {
            messages = try JSONDecoder().decode([ChatMessage].self, from: data)
        } catch {
            print("Failed to decode messages: \(error)")
            messages = []
        }
    }
    
    private func saveMessages() {
        do {
            let data = try JSONEncoder().encode(messages)
            messagesData = String(data: data, encoding: .utf8) ?? "[]"
        } catch {
            print("Failed to encode messages: \(error)")
        }
    }
}
