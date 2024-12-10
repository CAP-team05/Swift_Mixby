//
//  SwiftUIView.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI
struct RecipeTab: View {
    @Binding var tabSelection: Int
    @Binding var isLoading: Bool
    @Binding var ownedIngs: [String]
    @Binding var ownedTools: [String]
    
    @State private var tabOption: Int = 0
    @State private var noUnlocked: Bool = true
    @State private var noLocked: Bool = true
    
    @State private var unlockedRecipes: [RecipeDTO] = []
    @State private var lockedRecipes: [RecipeDTO] = []
    
    private let recipeHandler = RecipeHandler()
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var audioPlayer: AudioPlayer? = AudioPlayer()
    
    var body: some View {
        VStack (spacing: 0) {
            
            ZStack {
                // title dummy
                Rectangle()
                    .frame(height: UIScreen.screenHeight * 0.25)
                    .opacity(0.1)
                
                Button {
                    audioPlayer?.playSound(fileName: "refresh", fileType: "mp3", volume: 0.15)
                    isLoading = true
                    generateRecipeDTOsByGetKeywords(doPlus: true, keys: ownedIngs)
                    loadRecipes()
                } label: {
                    VStack (spacing: 2) {
                        Image(systemName: "arrow.clockwise.square")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                        Text("새로고침")
                            .font(.gbRegular10)
                            .foregroundColor(.white)
                    }
                }
                .offset(x: 130, y: -30)
                
            }
            
            TabOptions(
                tabOption: $tabOption,
                options: ["열림", "잠김"]
            )
            
            ZStack {
                if isLoading {
                    ProgressView("로딩 중...")
                        .font(.gbRegular20)
                        .foregroundColor(.white.opacity(isLoading ? 0.5 : 0))
                        .offset(y: -100)
                } else {
                    VStack {
                        if tabOption == 0 {
                            recipeGrid(
                                recipes: unlockedRecipes,
                                doNavigate: true,
                                isEmpty: $noUnlocked
                            )
                            if noUnlocked {
                                EmptyBox().offset(y: -500)
                            }
                        }
                        if tabOption == 1 {
                            recipeGrid(
                                recipes: lockedRecipes,
                                doNavigate: true,
                                isEmpty: $noLocked
                            )
                            if noLocked {
                                EmptyBox().offset(y: -500)
                            }
                        }
                        Spacer()
                    }
                }
            } // ZStack
            .frame(height: UIScreen.screenHeight - 300)
        } // VStack
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .onAppear {
            Task {
                loadRecipes()
            }
        }
    }
    
    @ViewBuilder
    func recipeGrid(recipes: [RecipeDTO], doNavigate: Bool, isEmpty: Binding<Bool>) -> some View {
        VStack {
            ScrollView {
                Spacer().frame(height: 10)
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<recipes.count, id: \.self) { index in
                        if doNavigate {
                            NavigationLink(
                                destination: RecipeView(
                                    recipeDTO: recipes[index],
                                    ownedTools: ownedTools,
                                    ownedIngs: ownedIngs
                                ), label: {
                                    RecipeCard(recipeDTO: recipes[index])
                                        .onAppear {
                                            isEmpty.wrappedValue = false
                                        }
                                }
                            )
                            .simultaneousGesture(
                                TapGesture().onEnded {
                                    audioPlayer?.playSound(fileName: "ice2", fileType: "mp3", volume: 0.1)
                                }
                            )
                        } else {
                            RecipeCard(recipeDTO: recipes[index])
                                .onAppear {
                                    isEmpty.wrappedValue = false
                                }
                        }
                    }
                }
                // bottom dummy
                Spacer().frame(height: 200)
            }
        }
    }
    
    func loadRecipes() {
        print("recipe loading start")
        
        Task {
            // 데이터 로드
            let loadedRecipes = RecipeHandler.searchAll()
            
            // UI 업데이트는 반드시 MainActor에서 실행
            await MainActor.run {
                unlockedRecipes = loadedRecipes.filter { $0.have.first == $0.have.last }
                lockedRecipes = loadedRecipes.filter { $0.have.first != $0.have.last }
                
                isLoading = false
                print("recipe loaded")
            }
        }
    }
}
