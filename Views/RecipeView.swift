//
//  RecipeView.swift
//  mixby2
//
//  Created by Anthony on 11/28/24.
//

import SwiftUI

struct RecipeView: View {
    var recipeDTO: RecipeDTO
    var ownedTools: [String]
    var ownedIngs: [String]
    
    @State var unLockingChallenges: [Int] = [3]
    
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    // static private let recipeHandler = RecipeHandler.shared
    
    var body: some View {
        ZStack {
            ViewBackground()
            
            VStack {
                Spacer().frame(height: 70)
                
                let image_url = URL(string: "http://cocktail.mixby.kro.kr:2222/recipe/image="+recipeDTO.english_name)
                
                HStack {
                    AsyncImage(url: image_url) { result in
                        result.image?
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 200, height: 200)
                    .cornerRadius(50)
                    .shadow(
                        color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                    )
                    
                    VStack (spacing: 30) {
                        Text(recipeDTO.korean_name)
                            .font(.gbBold30)
                            .foregroundColor(.yellow)
                        
                        Text("#\(recipeDTO.tag1) #\(recipeDTO.tag2)")
                            .font(.gbRegular22)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer().frame(height: 20)
                
                VStack(alignment: .leading, spacing: 20) {
                    TitleCard(title: "제조법").offset(x: 150)
                    
                    let instArray = getInstructionByCode(code: recipeDTO.code)
                    ForEach(0..<instArray.count, id: \.self) { i in
                        
                        let text = instArray[i].replacingOccurrences(of: "\n", with: "")
                        Text(text.replacingOccurrences(of: "\"", with: ""))
                            .font(.gbRegular20)
                            .foregroundColor(.yellow)
                            .lineLimit(2)
                            .lineSpacing(5)
                            // .multilineTextAlignment(.leading)
                            .frame(width: UIScreen.screenWidth-20, alignment: .leading)
                            .onAppear {
                                    if instArray[i].contains("얼음") { unLockingChallenges.append(9) } // 얼음 O
                                    else { unLockingChallenges.append(8) } // 얼음 X
                            }
                    }
                    
                    Spacer().frame(height: 20)
                    
                    TitleCard(title: "재료").offset(x: 150)
                    
                    let ings = getRecipeIngredients(recipe: recipeDTO)
                    
                    ScrollView (.vertical) {
                        VStack (spacing: 10) {
                            ForEach(0..<ings.count, id: \.self) { i in
                                HStack {
                                    let doHaveIng = ownedIngs.contains(ings[i].code)
                                    let doHaveDrink = DrinkHandler.shared.getAllDrinkCodes().contains(ings[i].code)
                                    
                                    Image(systemName: doHaveIng || doHaveDrink ? "checkmark.circle" : "x.circle")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                    
                                    Text(ings[i].name)
                                        .font(.gbRegular24)
                                        .foregroundColor(.white)
                                        .onAppear {
                                            if ings.count >= 5 { unLockingChallenges.append(5) }
                                            if ings[i].name == "우유" { unLockingChallenges.append(13) } // 우유
                                            if ings[i].name == "탄산" { unLockingChallenges.append(25) } // 탄산
                                        }
                                    
                                    Spacer()
                                    
                                    let re = reconfigureAmount(tools: ownedTools, amount: ings[i].amount, unit: ings[i].unit)
                                    Text(re)
                                        .font(.gbRegular20)
                                        .foregroundColor(.white)
                                }
                            }
                            Spacer().frame(height: 120)
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .onDisappear {
                for num in unLockingChallenges {
                    ChallengeHandler.shared.unlockChallenge(id: num)
                }
            }
        }
        // .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                navigationBarTrailingItem
            }
        }
    }
    
    private var navigationBarTrailingItem: some View {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let drinkDate = dateFormatter.string(from: Date())
        let tastingNoteDTO = TastingNoteDTO(
            code: recipeDTO.code,
            english_name: recipeDTO.english_name,
            korean_name: recipeDTO.korean_name,
            drinkDate: drinkDate
        )
        
        return NavigationLink(
            destination: TastingNoteView(tastingNoteDTO: tastingNoteDTO),
            label: {
                Image(systemName: "note.text")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
        )
    }
    
    func reconfigureAmount(tools: [String], amount: String, unit: String) -> String {
        var re: Float = 0
        
        if tools.contains("쉐이커") { unLockingChallenges.append(6) }
        if tools.contains("스트레이너") { unLockingChallenges.append(7) }
        
        if unit != "ml" {
            return amount
        }
        if tools.contains("숟가락") {
            unLockingChallenges.append(17)
            let intAmount = Float(amount) ?? 0
            re = round(intAmount / 10 * 10) / 10
            return String(re) + " 숟가락"
        }
        if tools.contains("소주잔") {
            unLockingChallenges.append(16)
            let intAmount = Float(amount) ?? 0
            re = round(intAmount / 50 * 10) / 10
            return String(re) + " 소주잔"
        }
        if tools.contains("종이컵") {
            let intAmount = Float(amount) ?? 0
            re = round(intAmount / 180 * 10) / 10
            return String(re) + " 종이컵"
        }
        
        return amount + unit
    }
}
