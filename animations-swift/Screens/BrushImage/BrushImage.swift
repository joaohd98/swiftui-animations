//
//  BrushAnimation.swift
//  animations-swift
//
//  Created by João Damazio on 20/06/24.
//

import SwiftUI
import AVKit

private let pictures: [UIImage] = [
    .picture0,
    .picture1,
    .picture2,
    .picture3,
    .picture4,
    .picture5,
    .picture6,
    .picture7
]

struct BrushImage: View {
    @State private var current = 1

    @State private var isDragging = false
    @State private var dragPrevProgress = 0.0
    @State private var dragNextProgress = 0.0

    @State private var initialPosition: CGPoint = .zero
    
    func calcMultiply(height: CGFloat, width: CGFloat) -> CGFloat {
        let positionX = initialPosition.x
        let positionY = initialPosition.y
        let centerX = width / 2.0
        let centerY = height / 2.0
        
        let maxDistance = sqrt(pow(centerX, 2) + pow(centerY, 2))
        let distance = sqrt(pow(positionX - centerX, 2) + pow(positionY - centerY, 2))
        
        let scaledValue = 2.5 + (distance / maxDistance) * (5.0 - 2.5)
        let clampedValue = min(max(scaledValue, 2.5), 5)
        
        return clampedValue
    }

    func drag(width: CGFloat, height: CGFloat) -> some Gesture {
        let hasPrev = current > 0
        let hasNext = current < pictures.count - 1
        
        return DragGesture()
            .onChanged { values in
                if self.isDragging == false {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    self.initialPosition = values.startLocation
                }
                        
                self.isDragging = true
                
                if values.translation.height == 0 {
                    self.dragPrevProgress = 0
                    self.dragNextProgress = 0
                }

                if hasNext && values.translation.height > 0 {
                    self.dragNextProgress = mapRange(
                        inMin: 0, inMax: height * 0.7, outMin: 0, outMax: 1, valueToMap: abs(values.translation.height)
                    )
                    
                    self.dragPrevProgress = 0
                } 
                
                if hasPrev && values.translation.height < 0 {
                    self.dragPrevProgress = mapRange(
                        inMin: 0, inMax: height * 0.7, outMin: 0, outMax: 1, valueToMap: abs(values.translation.height)
                    )

                    self.dragNextProgress = 0
                }
            }
            .onEnded { values in
                withAnimation(.timingCurve(0.1, 0, 0.2, 1, duration: 0.5)) {
                    self.dragNextProgress = hasNext && self.dragNextProgress > 0.1 ? 1 : 0
                    self.dragPrevProgress = hasPrev && self.dragPrevProgress > 0.1 ? 1 : 0
                } completion: {
                    self.isDragging = false
 
                    if self.dragNextProgress == 1 {
                        self.current += 1
                    }
                    
                    if self.dragPrevProgress == 1 {
                        self.current -= 1
                    }
                    
                    self.initialPosition = .zero
                    self.dragNextProgress = .zero
                    self.dragPrevProgress = .zero
                }
            }
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                let multiply = calcMultiply(
                    height: proxy.size.height, width: proxy.size.width
                )
                
                let hasPrev = current > 0
                let hasNext = current < pictures.count - 1

                if hasPrev {
                    let previous = pictures[current - 1]

                    Image(uiImage: previous)
                        .resizable()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .scaleEffect(1.1)
                }
                
                let dragPrev = 1 - dragPrevProgress

                Image(uiImage: pictures[current])
                    .resizable()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .scaleEffect(1.1)
                    .modifier(BrushImageModifierEffect(origin: initialPosition, dragProgress: dragNextProgress))
                    .blur(radius: interpolateValue(dragNextProgress, minValue: 0, maxValue: 30))
                    .opacity(dragPrev)
                
                
                if hasNext {
                    let next = pictures[current + 1]
                    
                    Image(uiImage: next)
                        .resizable()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .scaleEffect(1.1)
                        .mask {
                            let maxWidth = interpolateValue(
                                dragNextProgress, minValue: 50, maxValue: proxy.size.width * multiply
                            )
                            let maxHeight = interpolateValue(
                                dragNextProgress, minValue: 50, maxValue: proxy.size.height * multiply
                            )
                            
                            let offsetX = proxy.size.width / 2 - initialPosition.x
                            let offsetY = proxy.size.height / 2 - initialPosition.y
                            let opacity = mapRange(inMin: 0, inMax: 0.1, outMin: 0, outMax: 1, valueToMap: dragNextProgress)
                            
                            Circle()
                                .frame(width: maxWidth, height: maxHeight)
                                .opacity(interpolateValue(opacity, minValue: 0, maxValue: 1))
                                .offset(x: -offsetX, y: -offsetY)
                        }
                }
            }
            .gesture(drag(width: proxy.size.width, height: proxy.size.height))
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
}

#Preview {
    BrushImage()
}
