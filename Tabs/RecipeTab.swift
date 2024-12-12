//
//  SwiftUIView.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct RecipeTab: View {
    @Binding var tabSelection: Int
    @Binding var showBartender: Bool
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
        VStack {
            Spacer().frame(height: showBartender ? 250 : 150)
            
            TabOptions(
                tabOption: $tabOption,
                options: ["열림", "잠김"]
            )
            
            ZStack {
                if isLoading {
                    ProgressView("로딩 중...")
                        .font(.gbRegular20)
                        .foregroundColor(.white.opacity(0.5))
                } else {
                    if tabOption == 0 {
                        if noUnlocked {
                            EmptyBox().offset(y: showBartender ? -250 : -290)
                        }
                        recipeGrid(
                            recipes: unlockedRecipes,
                            doNavigate: true,
                            isEmpty: $noUnlocked
                        )
                    }
                    if tabOption == 1 {
                        if noLocked {
                            EmptyBox().offset(y: showBartender ? -250 : -290)
                        }
                        recipeGrid(
                            recipes: lockedRecipes,
                            doNavigate: true,
                            isEmpty: $noLocked
                        )
                    }
                }
            }
            Spacer()
            
        } // VStack
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .onAppear { Task { await loadRecipes() }}
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
    
    func loadRecipes() async {
        await MainActor.run {
            isLoading = true
        }
        
        // UI 업데이트는 반드시 MainActor에서 실행
        
        Task.detached {
            // 데이터 로드
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 테스트용 딜레이
            
            generateRecipeDTOsByGetKeywords(doPlus: true, keys: ownedIngs)
            
            await MainActor.run {
                let loadedRecipes = RecipeHandler.searchAll()
                unlockedRecipes = loadedRecipes.filter { $0.have.first == $0.have.last }
                lockedRecipes = loadedRecipes.filter { $0.have.first != $0.have.last }
                
                isLoading = false // 로딩 상태 종료
                print("recipe loaded")
            }
        }
    }
}
