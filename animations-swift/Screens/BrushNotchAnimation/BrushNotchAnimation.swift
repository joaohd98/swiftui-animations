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
    .picture0,
    .picture1,
    .picture2,
    .picture3,
    .picture4,
    .picture5,
    .picture6
]

struct BrushNotchAnimation: View {
    @State private var enterAnimation: Bool = false
    @State private var visibleAnimation: Bool = false
    
    @State private var isTextVisible = true
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
                }
                        
                self.isDragging = true
                
                if values.translation.height == 0 {
                    self.dragPrevProgress = 0
                    self.dragNextProgress = 0
                }

                if hasNext && values.translation.height > 0 {
                    self.initialPosition = values.location

                    self.dragNextProgress = mapRange(
                        inMin: 0, inMax: height * 0.9, outMin: 0, outMax: 1, valueToMap: abs(values.translation.height)
                    )
                    
                    self.dragPrevProgress = 0
                }
                
                if hasPrev && values.translation.height < 0 {
                    self.dragPrevProgress = mapRange(
                        inMin: 0, inMax: height * 0.9, outMin: 0, outMax: 1, valueToMap: abs(values.translation.height)
                    )

                    self.dragNextProgress = 0
                }
            }
            .onEnded { values in
                withAnimation(.timingCurve(0.1, 0, 0.2, 1, duration: 0.6)) {
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
                    self.isTextVisible = false
                }
            }
    }
    
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            let hasDynamicIsland = safeArea.top > 51

            Group {
                ZStack {
                    let multiply = calcMultiply(height: proxy.size.height, width: proxy.size.width)
                    
                    let hasPrev = current > 0
                    let hasNext = current < pictures.count - 1

                    if hasPrev {
                        let previous = pictures[current - 1]

                        Image(uiImage: previous)
                            .resizable()
                            .frame(width: proxy.size.width, height: proxy.size.height + safeArea.bottom + safeArea.top)
                            .scaleEffect(1.1)
                    }
                    
                    let dragPrev = 1 - dragPrevProgress

                    Image(uiImage: pictures[current])
                        .resizable()
                        .frame(width: proxy.size.width, height: proxy.size.height + safeArea.bottom + safeArea.top)
                        .scaleEffect(1.1)
                        .modifier(BrushImageModifierEffect(origin: initialPosition, dragProgress: dragNextProgress))
                        .opacity(dragPrev)
                        .overlay {
                            VStack {
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 32, height: 32)
                                    .overlay {
                                        Image(uiImage: .iaIcon)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 16, height: 16)
                                    }
                                    .anchorPreference(key: AnchorKey.self, value: .bounds, transform: {
                                        return ["header": $0]
                                    })
                                    .padding(.top, safeArea.top + 12)
                                    .padding(.top, enterAnimation ? 0 : hasDynamicIsland ? -56 : -60)


                                Spacer()
                                
                                Text("Trunk Hotel")
                                    .font(.custom("AutautGrotesk-Bold", size: 28))
                                    .lineSpacing(-0.28)
                                    .foregroundStyle(.white)
                                    .padding(.bottom, 8)
                                
                                Text("Tokyo, Japan")
                                    .font(.custom("AutautGrotesk-Medium", size: 14))
                                    .lineSpacing(-0.1)
                                    .foregroundStyle(.white)
                                    .padding(.bottom, 10)


                                HStack(spacing: 28) {
                                    Button {
                                       
                                        
                                    } label: {
                                        HStack(spacing: 12) {
                                            Image(uiImage: .plus)
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                    
                                            Text("Book")
                                                .foregroundStyle(.black)
                                                .font(.custom("AutautGrotesk-Semibold", size: 14))
                                                .lineSpacing(-0.1)

                                        }
                                        .frame(width: 94, height: 40)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                 
                                    
                                    Button {
                                        print("click three dots")
                                    } label: {
                                        Image(uiImage: .threeDots)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .background {
                                                Color.black.opacity(0.2)
                                                    .frame(width: 40, height: 40)
                                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                            }
                                    }
                                  
                                }
                                .padding(.bottom, 50)
                            }
                            .frame(maxWidth: .infinity)
                            .overlayPreferenceValue(AnchorKey.self, { pref in
                                VStack {
                                    GeometryReader { proxy in
                                        if let anchor = pref["header"] {
                                            let frameRect = proxy[anchor]
                                            Canvas { out, size in
                                                out.addFilter(.alphaThreshold(min: 0.5))
                                                out.addFilter(.blur(radius: 12))
                    
                                                out.drawLayer { ctx in
                                                    if let circle = out.resolveSymbol(id: 0) {
                                                        ctx.draw(circle, in: CGRect(
                                                            x: frameRect.minX - 3.5,
                                                            y: frameRect.minY - 3.5,
                                                            width: frameRect.width + 6.5,
                                                            height: frameRect.height + 6.5
                                                        ))
                                                    }
                                                    
                                                    if let dynamicIsland = out.resolveSymbol(id: 1) {
                                                        let rect = CGRect(
                                                            x: (size.width - 120) / 2,
                                                            y: hasDynamicIsland ? 12 : -10,
                                                            width: 120,
                                                            height: 37
                                                        )
                    
                                                       ctx.draw(dynamicIsland, in: rect)
                                                    }
                                                }
                                            } symbols: {
                                                Circle()
                                                    .tag(0)
                                                    .id(0)
                                                    .transition(.opacity)
                    
                                                RoundedRectangle(cornerRadius: 18)
                                                    .tag(1)
                                                    .id(1)
                                            }
                                        }
                                    }
                                    .allowsHitTesting(false)
                                }
                                .opacity(visibleAnimation ? 0 : 1)
                            })
                            .blur(radius: interpolateValue(dragNextProgress, minValue: 0, maxValue: 30))
                            .opacity(isTextVisible ? 1 : 0)
                            .opacity(1 - interpolateValue(dragNextProgress, minValue: 0, maxValue: 1))
                            .onChange(of: self.current) {
                                withAnimation {
                                    isTextVisible = true
                                }
                            }
                        }
                    
                    
                    if hasNext {
                        let next = pictures[current + 1]
                        
                        Image(uiImage: next)
                            .resizable()
                            .frame(width: proxy.size.width, height: proxy.size.height + safeArea.bottom + safeArea.top)
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
                                    .shadow(color: .red, radius: 10, x: -0.5, y: -0.5)
                                    .shadow(color: .red, radius: 10, x: 0.5, y: -0.5)
                                    .shadow(color: .red, radius: 10, x: -0.5, y: 0.5)
                                    .shadow(color: .red, radius: 10, x: 0.5, y: 0.5)
                                    .frame(width: maxWidth * 0.9, height: maxHeight * 0.9)
                                    .opacity(interpolateValue(opacity, minValue: 0, maxValue: 1))
                                    .offset(x: -offsetX, y: -offsetY)

                            }
                    }
                }
                .gesture(drag(width: proxy.size.width, height: proxy.size.height))
            }
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.spring(duration: 0.8, bounce: 0.5)) {
                    enterAnimation = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.linear(duration: 0.2)) {
                        visibleAnimation = true
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    BrushNotchAnimation()
}
