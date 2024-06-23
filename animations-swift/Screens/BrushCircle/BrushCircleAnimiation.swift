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

struct BrushCircleAnimation: View {
    @State private var counter = 0
    @State private var position = 0
    @State private var isDragging = false
    @State private var dragProgress = 0.0
    @State private var initialPosition: CGPoint = .zero
    @State private var currentPosition: CGPoint = .zero

    func drag(width: CGFloat, height: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { values in
                if self.isDragging == false {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    self.initialPosition = values.startLocation
                }
                
                self.currentPosition = values.location
        
                self.isDragging = true
                self.dragProgress = mapRange(
                    inMin: 0, inMax: height, outMin: 0, outMax: 1, valueToMap: abs(values.translation.height)
                )
            }
            .onEnded { values in
                self.counter += 1

                withAnimation {
                    self.dragProgress = self.dragProgress > 0.15 ? 1 : 0
                } completion: {
                    self.isDragging = false
                    self.initialPosition = .zero
                    self.currentPosition = .zero
                }
            }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image(uiImage: .newYork)
                    .resizable()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .modifier(BrushModifierEffect(origin: initialPosition, destination: currentPosition))
                    .blur(radius: interpolateValue(dragProgress, minValue: 0, maxValue: 24))
         
                Image(uiImage: .grandCanal)
                    .resizable()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .mask {
                        let maxWidth = interpolateValue(dragProgress, minValue: 50, maxValue: proxy.size.width * 4)
                        let maxHeight = interpolateValue(dragProgress, minValue: 50, maxValue: proxy.size.height * 4)
                        
                        let offsetX = proxy.size.width / 2 - initialPosition.x
                        let offsetY = proxy.size.height / 2 - initialPosition.y
                        
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
                        .offset(x: -offsetX, y: -offsetY)
                    }
            }
            .gesture(drag(width: proxy.size.width, height: proxy.size.height))
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
}

#Preview {
    BrushCircleAnimation()
}
