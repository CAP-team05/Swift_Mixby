//
//  SevenButtons.swift
//  mixby2
//
//  Created by Anthony on 12/3/24.
//

import SwiftUI

struct SevenButtons: View {
    @Binding var value: Int
    @State private var sliderValue: Double = 4 // 슬라이더 초기값
    @State private var isDragging: Bool = false // 드래그 상태
    private let emojiValues = ["😢", "😟", "😀", "😍", "🙂", "🙁", "😖"]
    
    var title: String = "SevenButtons"
    var color: Color = .white

    var body: some View {
        VStack {
            Text(title)
                .font(.gbRegular18)
                .foregroundColor(color)
            
            GeometryReader { geometry in
                ZStack {
                    // 슬라이더
                    Slider(
                        value: $sliderValue,
                        in: 1...7,
                        step: 1,
                        onEditingChanged: { editing in
                            isDragging = editing
                            if !editing {
                                value = Int(sliderValue) - 1 // 값 업데이트
                            }
                        }
                    )
                    .padding()

                    // 이모지 표시
                    if isDragging {
                        let totalWidth = geometry.size.width - 32
                        let stepWidth = totalWidth / 6 - 4.5
                        let emojiPosition = CGFloat(sliderValue - 1) * stepWidth + 30

                        
                        ZStack {
                            Rectangle()
                                .fill(Color.yellow.opacity(0.9))
                                .frame(width: 60, height: 70)
                                .mask(
                                    ZStack {
                                        Circle()
                                            .frame(width: 50, height: 50)
                                        Triangle()
                                            .frame(width: 20, height: 10)
                                            .rotationEffect(.degrees(180))
                                            .offset(y: 25)
                                    }
                                )
                            
                            Text(emojiValues[Int(sliderValue) - 1])
                                .font(.system(size: 26))
                        }
                        .frame(width: 60, height: 70)
                        .position(x: emojiPosition, y: geometry.size.height / 2 - 40)
                        .zIndex(1)
                    }
                }
                .frame(height: 30)
            }
            .frame(height: 30)
            .onAppear {
                // 부모의 value 값과 sliderValue 동기화
                sliderValue = Double(value + 1)
                print("onAppear: sliderValue set to \(sliderValue)")
            }
        }
        .frame(width: UIScreen.main.bounds.width - 40)
        .onChange(of: value) { _, newValue in
            sliderValue = Double(newValue + 1) // value가 변경되면 sliderValue 업데이트
            print("onChange: sliderValue updated to \(sliderValue)")
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct SevenButtons_Previews: PreviewProvider {
    @State static private var selectedValue: Int = 5 // Preview를 위한 상태 변수
    
    static var previews: some View {
        SevenButtons(
            value: $selectedValue,
            title: "Select Option",
            color: .blue
        )
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}
