//
//  BrushAnimation.swift
//  animations-swift
//
//  Created by João Damazio on 20/06/24.
//

import SwiftUI
import AVKit

let pictures: [UIImage] = [
    .picture0,
    .picture1,
    .picture2,
    .picture3,
    .picture4,
    .picture5,
    .picture6
]

struct BrushImage: View {
    @State private var current = 1

    @State private var isDragging = false
    @State private var dragPrevProgress = 0.0
    @State private var dragNextProgress = 0.0

    @State private var initialPosition: CGPoint = .zero
    

    func drag(width: CGFloat, height: CGFloat) -> some Gesture {
        let hasPrev = current > 0
        let hasNext = current < pictures.count - 1
        
        return DragGesture()
            .onChanged { values in
                if self.isDragging == false {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    
                    withAnimation {
                        self.initialPosition = values.startLocation
                    }
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
                withAnimation {
                    self.dragNextProgress = hasNext && self.dragNextProgress > 0.1 ? 1 : 0
                    self.dragPrevProgress = hasPrev && self.dragPrevProgress > 0.1 ? 1 : 0
                } completion: {
                    self.isDragging = false
 
                    if self.dragNextProgress > 0 {
                        self.current += 1
                    }
                    
                    if self.dragPrevProgress > 0 {
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
                let hasPrev = current > 0
                let hasNext = current < pictures.count - 1

                if hasPrev {
                    let previous = pictures[current - 1]

                    Image(uiImage: previous)
                        .resizable()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
                
                Image(uiImage: pictures[current])
                    .resizable()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .modifier(BrushImageModifierEffect(origin: initialPosition, dragProgress: dragNextProgress))
                    .mask {
                        let dragPrev = 1 - dragPrevProgress
                        let maxWidth = interpolateValue(dragPrev, minValue: 0, maxValue: proxy.size.width * 2.5)
                        let maxHeight = interpolateValue(dragPrev, minValue: 0, maxValue: proxy.size.height * 2.5)
                        
                        let offsetX = 0.0
                        let offsetY = 0.0

                        Circle()
                            .frame(width: maxWidth, height: maxHeight)
                            .opacity(1)
                            .offset(x: -offsetX, y: -offsetY)
                    }
                
                
                if hasNext {
                    let next = pictures[current + 1]
                    
                    Image(uiImage: next)
                        .resizable()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .mask {
                            let maxWidth = interpolateValue(
                                dragNextProgress, minValue: 50, maxValue: proxy.size.width * 2.5
                            )
                            let maxHeight = interpolateValue(
                                dragNextProgress, minValue: 50, maxValue: proxy.size.height * 2.5
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
