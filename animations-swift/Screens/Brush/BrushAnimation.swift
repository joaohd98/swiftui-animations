//
//  BrushAnimation.swift
//  animations-swift
//
//  Created by João Damazio on 20/06/24.
//

import SwiftUI
import AVKit

enum DirectionHorizontal {
    case left, right, center, none
}

enum DirectionVertical {
    case up, down, none
}

struct BrushAnimation: View {
    @State private var position = 0
    @State private var isDragging = false
    @State private var dragProgress = 0.0
    @State private var directionHorizontal: DirectionHorizontal = .none
    @State private var directionVertical: DirectionVertical = .none

    func calculateDirection(_ x: CGFloat, _ width: CGFloat) -> DirectionHorizontal {
        if x > width * 0.65 {
            return .right
        } else if x < width * 0.35 {
            return .left
        } else {
            return .center
        }
    }

    func drag(width: CGFloat, height: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { values in
                if self.isDragging == false {
                    self.directionHorizontal = calculateDirection(values.startLocation.x, width)
                }
        
                self.isDragging = true
                self.dragProgress = mapRange(
                    inMin: 0, inMax: height, outMin: 0, outMax: 1, valueToMap: abs(values.translation.height)
                )
            }
            .onEnded { values in
                withAnimation {
                    self.dragProgress = self.dragProgress > 0.15 ? 1 : 0
                } completion: {
                    self.isDragging = false
                    self.directionVertical = .none
                }
            }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VideoLoop(
                    name: "new-york",
                    height: proxy.size.height,
                    width: proxy.size.width
                )
                .blur(radius: interpolateValue(dragProgress, minValue: 0, maxValue: 24))
         
                VideoLoop(
                    name: "grand-canal",
                    height: proxy.size.height,
                    width: proxy.size.width
                )
                .mask {
                    let maxWidth = interpolateValue(dragProgress, minValue: 150, maxValue: proxy.size.width * 4)
                    let maxHeight = interpolateValue(dragProgress, minValue: 150, maxValue: proxy.size.height * 4)
                    let offsetX = self.directionHorizontal == .right ? proxy.size.width / 2 : self.directionHorizontal == .center ? 0 : -proxy.size.width / 2
                    
                    ZStack {
                        Circle()
                            .frame(width: maxWidth, height: maxHeight)
                        
                        Circle()
                            .frame(width: maxWidth * 1.1, height: maxHeight * 1.2)
                            .opacity(0.9)
                        
                        Circle()
                            .frame(width: maxWidth * 1.2, height: maxHeight * 1.2)
                            .opacity(0.6)
                        Circle()
                            .frame(width: maxWidth * 1.3, height: maxHeight * 1.3)
                            .opacity(0.3)
                    }
                    .opacity(interpolateValue(dragProgress * 4, minValue: 0, maxValue: 1))
                    .offset(x: offsetX, y: -proxy.size.height / 2)
                }
            }
            .gesture(drag(width: proxy.size.width, height: proxy.size.height))
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
}

#Preview {
    BrushAnimation()
}
