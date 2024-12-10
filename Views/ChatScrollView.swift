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
    
    @Binding var lastUpdate: Date
    
    @State private var messages: [ChatMessage] = []
    
    @State private var visibleMessages: Set<Int> = []
    @State private var messageID: Int = 0
    
    @State private var clickedButton: String = "None"
    @State private var canClickButton: Bool = true
    @State private var inputMode: Int = 0
    
    private let buttonOptions = ["계절", "시간", "날씨", "기분", "일정"]
    private let feelingOptions = ["행복", "피곤", "화남", "뒤로"]
    private let scheduleOptions = ["바쁨", "한가", "여행", "뒤로"]
    
    var ownedTools: [String]
    
    var audioPlayer: AudioPlayer? = AudioPlayer()
    
    var body: some View {
        ZStack {
            Button(
                action: {
                    audioPlayer?.playSound(fileName: "refresh", fileType: "mp3", volume: 0.15)
                    resetChat()
                    print("reset chat")
                }, label: {
                    VStack (spacing: 2) {
                        Image(systemName: "trash.square")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                        Text("초기화")
                            .font(.gbRegular10)
                            .foregroundColor(.white)
                    }
                })
            .offset(x: 130, y: -410)
            
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 10) {
                            Spacer().frame(height: 20)
                            welcomeMessage
                            messageList
                            Spacer().frame(height: 170).id("BottomDummy")
                        }
                    }
                    .background(Color.gray.opacity(0.2))
                    .onChange(of: messages.count) { _, _ in
                        scrollToBottom(proxy: proxy)
                    }
                }
            }
            inputSection
        }
        .onAppear {
            print("main page appeared")
            canClickButton = true
            loadMessages()
            inputMode = 0
        }
    }
    
    private var welcomeMessage: some View {
        let userName = UserHandler.searchAll().last?.name ?? ""
        return BartenderChatBubble(firstLine: "\(userName)님, 환영합니다.", secondLine: "어떤 술을 추천드릴까요?")
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
            Spacer().frame(height: 120)
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
        if canClickButton {
            canClickButton = false
            
        addMessage(type: "User", param: buttonOptions[index], recipe: nil)
        
            if index >= 3 {
                audioPlayer?.playSound(fileName: "drop", fileType: "mp3", volume: 0.15)
                withAnimation { inputMode = index - 2 }
                addMessage(type: "Bartender", param: buttonOptions[index], recipe: nil)
            } else {
                let recommendDTOs = RecommendHandler.searchAll()
                let cnt = recommendDTOs.count
                print("recommend count: \(cnt)")
                
                audioPlayer?.playSound(fileName: "ice", fileType: "mp3", volume: 0.05)
                
                if index < cnt {
                    addMessage(
                        type: "Recommand",
                        param: buttonOptions[index],
                        recipe: getRecipeDTObyName(name: recommendDTOs[index].name),
                        reason: recommendDTOs[index].reason,
                        tag: recommendDTOs[index].tag
                    )
                } else {
                    addMessage(
                        type: "Bartender",
                        param: buttonOptions[index],
                        recipe: getRandomRecipe(),
                        reason: "out of range",
                        tag: "그냥"
                    )
                }
            }
            canClickButton = true
        }
    }
    
    private func handleFeelingInput(_ index: Int) {
        print("handleFeelingInput, index: \(index)")
        withAnimation { inputMode = 0 }
        
        addMessage(type: "Option", param: getImoji(param: feelingOptions[index]) + feelingOptions[index], recipe: nil)
        
        if index == 3 {
            audioPlayer?.playSound(fileName: "drop", fileType: "mp3", volume: 0.15)
        } else {
            let recommendDTOs = RecommendHandler.searchAll()
            let cnt = recommendDTOs.count
            print("recommend count: \(cnt)")
            
            audioPlayer?.playSound(fileName: "ice", fileType: "mp3", volume: 0.05)
            
            if index+3 < cnt {
                addMessage(
                    type: "Recommand",
                    param: buttonOptions[index],
                    recipe: getRecipeDTObyName(name: recommendDTOs[index+3].name),
                    reason: recommendDTOs[index+3].reason,
                    tag: recommendDTOs[index+3].tag
                )
            } else {
                addMessage(
                    type: "Bartender",
                    param: buttonOptions[index],
                    recipe: getRandomRecipe(),
                    reason: "out of range",
                    tag: "그냥"
                )
            }
        }
    }
    
    private func handleScheduleInput(_ index: Int) {
        print("handleScheduleInput, index: \(index)")
        withAnimation { inputMode = 0 }
        
        if index == 3 {
            audioPlayer?.playSound(fileName: "drop", fileType: "mp3", volume: 0.15)
        } else {
            let recommendDTOs = RecommendHandler.searchAll()
            let cnt = recommendDTOs.count
            print("recommend count: \(cnt)")
            
            audioPlayer?.playSound(fileName: "ice", fileType: "mp3", volume: 0.05)
            
            if index+6 < cnt {
                addMessage(
                    type: "Recommand",
                    param: buttonOptions[index],
                    recipe: getRecipeDTObyName(name: recommendDTOs[index+6].name),
                    reason: recommendDTOs[index+6].reason,
                    tag: recommendDTOs[index+6].tag
                )
            } else {
                addMessage(
                    type: "Bartender",
                    param: buttonOptions[index],
                    recipe: getRandomRecipe(),
                    reason: "out of range",
                    tag: "그냥"
                )
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
                    .onAppear { canClickButton = true }
                
            case "Option":
                OptionBubble(param: message.param)
                    .onAppear { canClickButton = true }
                
            case "Bartender":
                BartenderChatBubble(
                    firstLine: getPromptTitle(for: message.param),
                    secondLine: "아래 옵션을 선택해주세요."
                )
                .onAppear { canClickButton = true }
                
            case "Recommand":
                RecommendBubble(
                    recipeDTO: message.recipe ?? getRandomRecipe(), reason: message.reason, tag: message.tag
                )
                .onAppear { canClickButton = true }
                
            default:
                EmptyView()
            }
        }
        .id(message.id)
        .opacity(visibleMessages.contains(message.id) ? 1 : 0)
        .onAppear {
            canClickButton = true
            withAnimation {
                _ = visibleMessages.insert(message.id)
            }
        }
    }
    
    private func getPromptTitle(for param: String) -> String {
        param == "기분" ? "어떤 기분이신가요?" : "어떤 일정을 보내셨나요?"
    }
    
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation {
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
