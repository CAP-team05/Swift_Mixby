//
//  SwiftUIView.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI
struct RecipeTab: View {
    @Binding var tabSelection: Int
    @Binding var ownedIngs: [String]
    @Binding var isLoading: Bool
    
    @State private var tabOption: Int = 0
    @State private var noUnlocked: Bool = true
    @State private var noLocked: Bool = true
    
    @State private var unlockedRecipes: [RecipeDTO] = []
    @State private var lockedRecipes: [RecipeDTO] = []
    
    private let recipeHandler = RecipeHandler()
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    
    var body: some View {
        VStack {
            Rectangle()
                .frame(height: 280)
                .opacity(0.1)
            
            TabOptions(
                tabOption: $tabOption,
                options: ["열림", "잠김"]
            )
            
            ZStack {
                if isLoading {
                    ProgressView("로딩 중...")
                        .font(.gbRegular20)
                        .foregroundColor(.white.opacity(0.5))
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
                                doNavigate: false,
                                isEmpty: $noLocked
                            )
                            if noLocked {
                                EmptyBox().offset(y: -500)
                            }
                        }
                        Spacer()
                    }
                }
            }
            .frame(height: UIScreen.screenHeight - 300)
        }
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .onAppear {
            Task {
                await loadRecipes()
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
                                    tabSelection: $tabSelection,
                                    recipeDTO: recipes[index]
                                ), label: {
                                    RecipeCard(recipeDTO: recipes[index])
                                        .onAppear {
                                            isEmpty.wrappedValue = false
                                        }
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
        if !isLoading && tabSelection==1 {
            await MainActor.run {
                isLoading = true
            }
            
            // 데이터 로드
            await Task.detached {
                generateRecipeDTOsByGetKeywords(doPlus: true, keys: ownedIngs)
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 테스트용 딜레이
                let loadedRecipes = recipeHandler.fetchAllRecipes()
                
                await MainActor.run {
                    unlockedRecipes = loadedRecipes.filter { $0.have.first == $0.have.last }
                    lockedRecipes = loadedRecipes.filter { $0.have.first != $0.have.last }
                    isLoading = false
                }
            }
        }
    }
}
