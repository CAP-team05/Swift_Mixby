//
//  ChatBubble.swift
//  mixby2
//
//  Created by Anthony on 12/9/24.
//

import SwiftUI

struct BubbleShape: Shape {
    var myMessage: Bool
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        let bezierPath = UIBezierPath()
        if !myMessage {
            bezierPath.move(to: CGPoint(x: 25, y: height))
            bezierPath.addLine(to: CGPoint(x: width - 20, y: height))
            bezierPath.addCurve(
                to: CGPoint(x: width, y: height - 20),
                controlPoint1: CGPoint(x: width - 10, y: height),
                controlPoint2: CGPoint(x: width, y: height - 10)
            )
            bezierPath.addLine(to: CGPoint(x: width, y: 20))
            bezierPath.addCurve(
                to: CGPoint(x: width - 20, y: 0),
                controlPoint1: CGPoint(x: width, y: 10),
                controlPoint2: CGPoint(x: width - 10, y: 0)
            )
            bezierPath.addLine(to: CGPoint(x: 25, y: 0))
            bezierPath.addCurve(
                to: CGPoint(x: 5, y: 20),
                controlPoint1: CGPoint(x: 15, y: 0),
                controlPoint2: CGPoint(x: 5, y: 10)
            )
            bezierPath.addLine(to: CGPoint(x: 5, y: height - 10))
            bezierPath.addCurve(
                to: CGPoint(x: 0, y: height),
                controlPoint1: CGPoint(x: 5, y: height - 1),
                controlPoint2: CGPoint(x: 0, y: height)
            )
            bezierPath.addLine(to: CGPoint(x: -1, y: height))
            bezierPath.addCurve(
                to: CGPoint(x: 12, y: height - 4),
                controlPoint1: CGPoint(x: 4, y: height + 1),
                controlPoint2: CGPoint(x: 8, y: height - 1)
            )
            bezierPath.addCurve(
                to: CGPoint(x: 25, y: height),
                controlPoint1: CGPoint(x: 20, y: height),
                controlPoint2: CGPoint(x: 25, y: height)
            )
        } else {
            bezierPath.move(to: CGPoint(x: width - 25, y: height))
            bezierPath.addLine(to: CGPoint(x: 20, y: height))
            bezierPath.addCurve(
                to: CGPoint(x: 0, y: height - 20),
                controlPoint1: CGPoint(x: 10, y: height),
                controlPoint2: CGPoint(x: 0, y: height - 10)
            )
            bezierPath.addLine(to: CGPoint(x: 0, y: 20))
            bezierPath.addCurve(
                to: CGPoint(x: 20, y: 0),
                controlPoint1: CGPoint(x: 0, y: 10),
                controlPoint2: CGPoint(x: 10, y: 0)
            )
            bezierPath.addLine(to: CGPoint(x: width - 25, y: 0))
            bezierPath.addCurve(
                to: CGPoint(x: width - 5, y: 20),
                controlPoint1: CGPoint(x: width - 15, y: 0),
                controlPoint2: CGPoint(x: width - 5, y: 10)
            )
            bezierPath.addLine(to: CGPoint(x: width - 5, y: height - 10))
            bezierPath.addCurve(
                to: CGPoint(x: width, y: height),
                controlPoint1: CGPoint(x: width - 5, y: height - 1),
                controlPoint2: CGPoint(x: width, y: height)
            )
            bezierPath.addLine(to: CGPoint(x: width + 1, y: height))
            bezierPath.addCurve(
                to: CGPoint(x: width - 12, y: height - 4),
                controlPoint1: CGPoint(x: width - 4, y: height + 1),
                controlPoint2: CGPoint(x: width - 8, y: height - 1)
            )
            bezierPath.addCurve(
                to: CGPoint(x: width - 25, y: height),
                controlPoint1: CGPoint(x: width - 20, y: height),
                controlPoint2: CGPoint(x: width - 25, y: height)
            )
        }
        return Path(bezierPath.cgPath)
    }
}

#Preview {
    Rectangle()
        .frame(width: 300, height: 80)
        .overlay(Text("Hello World!").foregroundColor(.white))
        .mask(
            BubbleShape(myMessage: true)
        )
}
