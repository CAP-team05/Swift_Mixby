//
//  ChatScrollView.swift
//  mixby2
//
//  Created by Anthony on 12/9/24.
//

import SwiftUI

struct ChatScrollView: View {
    @State private var messages: [(type: String, param: String, id: Int, recipe: RecipeDTO?)] = [] // 메시지 데이터
    @State private var visibleMessages: Set<Int> = [] // 표시되는 메시지 ID
    @State private var messageID: Int = 0 // 고유 메시지 ID
    
    @State private var clickedButton: String = "None"
    @State private var gotAnswer: Bool = true
    private let buttonOptions = ["계절", "시간", "날씨", "기분"]
    
    var ownedTools: [String]
    
    var body: some View {
        ZStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        Spacer().frame(height: 20)
                        
                        VStack(spacing: 10) {
                            BartenderChatBubble()
                            
                            ForEach(messages, id: \.id) { message in
                                messageView(for: message)
                            }
                            
                            Spacer().frame(height: 170).id("BottomDummy") // 바텀 더미에 고유 ID 추가
                        }
                    }
                    .background(Color.gray.opacity(0.2))
                    .onChange(of: messages.count) { _, _ in
                        withAnimation {
                            proxy.scrollTo("BottomDummy", anchor: .bottom) // 바텀 더미로 스크롤
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack(spacing: 10) {
                    Spacer().frame(width: 10)
                    
                    ForEach(buttonOptions.indices, id: \.self) { index in
                        Button(action: {
                            if gotAnswer {
                                clickedButton = buttonOptions[index]
                                addMessage(type: "User", param: buttonOptions[index], recipe: nil)
                                gotAnswer = false // 다른 버튼이 눌리지 않도록 설정
                                
                                print("Getting Recommendations")
                                getRecommend(weather: "맑음") { result in
                                    print(result)
                                }
                                
                                // "Bartender" 타입 메시지 추가
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    let recipe = getRandomRecipe()
                                    addMessage(type: "Bartender", param: buttonOptions[index], recipe: recipe)
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    gotAnswer = true // 응답 완료 후 버튼 활성화
                                }
                            }
                            print("Button Clicked: \(buttonOptions[index])")
                        }) {
                            Recommands(param: buttonOptions[index])
                        }
                    }
                    
                    Spacer().frame(width: 10)
                }
                Spacer().frame(height: 120)
            }
        }
    }
    
    private func addMessage(type: String, param: String, recipe: RecipeDTO?) {
        messageID += 1
        messages.append((type: type, param: param, id: messageID, recipe: recipe))
    }
    
    private func messageView(for message: (type: String, param: String, id: Int, recipe: RecipeDTO?)) -> some View {
        Group {
            if message.type == "User" {
                UserBubble(param: message.param, res: "맑음")
            } else if message.type == "Bartender" {
                if let recipe = message.recipe {
                    NavigationLink(destination: {
                        RecipeView(recipeDTO: recipe, ownedTools: ownedTools)
                    }, label: { RecommandBubble(recipeDTO: recipe) })
                } else {
                    Text("Loading...").foregroundColor(.gray)
                }
            }
        }
        .opacity(visibleMessages.contains(message.id) ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                _ = visibleMessages.insert(message.id)
            }
        }
        .id(message.id)
    }
}
