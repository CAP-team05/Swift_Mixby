//
//  SwiftUIView.swift
//  mixby2
//
//  Created by Anthony on 11/27/24.
//

import SwiftUI

struct NoteTab: View {
    @Binding var isLoading: Bool
    
    @State private var noUnwritten: Bool = true
    @State private var noWritten: Bool = true
    
    @State private var tabOption: Int = 0
    @State private var writtenNotes: [TastingNoteDTO] = []
    @State private var unwrittenNotes: [TastingNoteDTO] = []
    
    
    var body: some View {
        let noteDTOs = TastingNoteHandler.searchAll()
        
        let unwrittenNoteDTOs = noteDTOs.filter { $0.eval == -1 }
        let writtenNoteDTOs = noteDTOs.filter { $0.eval != -1 }
        
        VStack {
            // title dummy
            Rectangle()
                .frame(height: 280)
                .opacity(0.1)
            
            TabOptions(
                tabOption: $tabOption,
                options: ["작성 중", "작성 완료"]
            )
            
            ZStack {
                if isLoading {
                    ProgressView("로딩 중...")
                        .font(.gbRegular20)
                        .foregroundColor(.white.opacity(0.5))
                        .offset(y: -100)
                } else {
                    if tabOption == 0 {
                        ScrollView(.vertical) {
                            Spacer().frame(height: 10)
                            LazyVStack (spacing: 20) {
                                ForEach(0..<unwrittenNoteDTOs.count, id: \.self) { index in
                                    NavigationLink(
                                        destination:
                                            TastingNoteView(tastingNoteDTO: unwrittenNoteDTOs[index])
                                            .onAppear {
                                                print("new note appeared")
                                                print(unwrittenNoteDTOs[index].eval)
                                                print(unwrittenNoteDTOs[index].sweetness)
                                                print(unwrittenNoteDTOs[index].sourness)
                                                print(unwrittenNoteDTOs[index].alcohol)
                                            }
                                        
                                        , label: {
                                            NoteCard(noteDTO: unwrittenNoteDTOs[index])
                                                .onAppear {
                                                    noUnwritten = false
                                                }
                                        }
                                    )
                                }
                            } // Grid 1
                            
                            // bottom dummy
                            Spacer().frame(height: 200)
                            
                        } // Scroll View
                        
                        if noUnwritten {
                            EmptyBox().offset(y: 0)
                        }
                    }
                    
                    if tabOption == 1 {
                        ScrollView(.vertical) {
                            Spacer().frame(height: 10)
                            LazyVStack (spacing: 20) {
                                ForEach(0..<writtenNoteDTOs.count, id: \.self) { index in
                                    NavigationLink(
                                        destination:
                                            TastingNoteView(tastingNoteDTO: writtenNoteDTOs[index])
                                        
                                        , label: {
                                            NoteCard(noteDTO: writtenNoteDTOs[index])
                                                .onAppear {
                                                    noWritten = false
                                                }
                                        }
                                    )
                                }
                            } // Grid 1
                            
                            // bottom dummy
                            Spacer().frame(height: 200)
                            
                        } // Scroll View
                        
                        if noWritten {
                            EmptyBox().offset(y: 0)
                        }
                    }
                    Spacer()
                }
            }
            .frame(height: UIScreen.screenHeight-300)
            
        } // VStack
        .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        .onAppear {
            Task {
                await loadNotes()
            }
        }
    }
    
    func loadNotes() async {
        if !isLoading {
            await MainActor.run {
                isLoading = true
            }
            
            // 데이터 로드
            await Task.detached {
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 테스트용 딜레이
                let loadedNotes = TastingNoteHandler.searchAll()
                let loadedRecipes = RecipeHandler.searchAll()
                
                await MainActor.run {
                    let unlockedRecipes: [RecipeDTO] = loadedRecipes.filter { $0.have.first == $0.have.last }
                    
                    generateTastingsNoteByRecipeDTOs(recipeDTOs: unlockedRecipes)
                    
                    isLoading = false
                }
            }
        }
    }
}
