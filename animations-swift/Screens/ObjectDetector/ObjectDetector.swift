//
//  ObjectDetector.swift
//  animations-swift
//
//  Created by João Damazio on 28/06/24.
//

import SwiftUI
import SwiftUI
import PhotosUI
import VisionKit

private struct Picture {
    var image: UIImage;
    var name: String;
    var location: String;
    var type: String;
}

struct Bound: Identifiable {
    var id: String
    var tapped: CGPoint
    var object: CGRect
    
    init(tapped: CGPoint, object: CGRect) {
        self.id = "\(object.width) \(object.height) \(object.midX) \(object.midY)"
        self.tapped = tapped
        self.object = object
    }
}


private let pictures: [Picture] = [
    .init(image: .picture0, name: "Toyokawa House", location: "Toyokawa, Japan", type: "Book"),
    .init(image: .picture1, name: "Conran Shop", location: "Tokyo, Japan", type: "Book"),
    .init(image: .picture2, name: "Bright House", location: "Sintra, Portugal", type: "Book"),
    .init(image: .picture3, name: "Ligre Youn", location: "Near you", type: "Book"),
    .init(image: .picture4, name: "Pan Cabins", location: "Espen Surnevik", type: "Book"),
    .init(image: .picture5, name: "Nike Shoe", location: "Nike, Men’s shoe", type: "Shop"),
    .init(image: .picture6, name: "Dream Space", location: "Montreal, Canada", type: "Book"),
    .init(image: .picture7, name: "Trunk Hotel", location: "Tokyo, Japan", type: "Book"),
    .init(image: .picture0, name: "Toyokawa House", location: "Toyokawa, Japan", type: "Book"),
    .init(image: .picture1, name: "Conran Shop", location: "Tokyo, Japan", type: "Book"),
    .init(image: .picture2, name: "Bright House", location: "Sintra, Portugal", type: "Book"),
    .init(image: .picture3, name: "Ligre Youn", location: "Near you", type: "Book"),
    .init(image: .picture4, name: "Pan Cabins", location: "Espen Surnevik", type: "Book"),
    .init(image: .picture5, name: "Nike Shoe", location: "Nike, Men’s shoe", type: "Shop"),
    .init(image: .picture6, name: "Dream Space", location: "Montreal, Canada", type: "Book"),
    .init(image: .picture7, name: "Trunk Hotel", location: "Tokyo, Japan", type: "Book")
]

struct ObjectDetector: View {
 
    @StateObject private var viewModel = ImageAnalysisViewModel()
    @State private var arrBounds: [Bound] = []

    @State private var isTextVisible = true
    @State private var current = 1

    @State private var isDragging = false
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
        let hasNext = current < pictures.count - 1
        
        return DragGesture()
            .onChanged { values in
                if self.isDragging == false {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                        
                self.isDragging = true
                
                if values.translation.height == 0 {
                    self.dragNextProgress = 0
                }

                if hasNext && values.translation.height > 0 {
                    self.initialPosition = values.location

                    self.dragNextProgress = mapRange(
                        inMin: 0, inMax: height * 0.9, outMin: 0, outMax: 1, valueToMap: abs(values.translation.height)
                    )
                }
            }
            .onEnded { values in
                withAnimation(.timingCurve(0.1, 0, 0.2, 1, duration: 0.6)) {
                    self.dragNextProgress = hasNext && self.dragNextProgress > 0.1 ? 1 : 0
                } completion: {
                    self.isDragging = false
 
                    if self.dragNextProgress == 1 {
                        self.isTextVisible = false
                        self.current += 1
                        self.arrBounds = []
                    }
                    
                    self.initialPosition = .zero
                    self.dragNextProgress = .zero
                }
            }
    }
    
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets

            Group {
                ZStack {
                    let multiply = calcMultiply(height: proxy.size.height, width: proxy.size.width)
                    
                    let hasPrev = current > 0
                    let hasNext = current < pictures.count - 1

                    if hasPrev {
                        let previous = pictures[current - 1]

                        Image(uiImage: previous.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: proxy.size.height + safeArea.bottom + safeArea.top)
                            .scaleEffect(1.05)
                    }
                    
                    ZStack {
                        
                        ObjectPickableImageView(uiImage: pictures[current].image)
                            .frame(width: proxy.size.width, height: proxy.size.height + safeArea.bottom + safeArea.top)
                            .scaleEffect(1.05)
                            .environmentObject(viewModel)
                            .onAppear {
                                Task { @MainActor in
                                    try? await self.viewModel.analyzeImage(pictures[current].image)
                                }
                            }
                            .onChange(of: current, { _, newValue in
                                Task { @MainActor in
                                    try? await self.viewModel.analyzeImage(pictures[current].image)
                                }
                            })
                            .opacity(0)

                        ZStack {
                            Image(uiImage: pictures[current].image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: proxy.size.height + safeArea.bottom + safeArea.top)
                                .scaleEffect(1.05)
                                .overlay {
                                    ForEach(arrBounds) { bound in
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 12, height: 12)
                                            .position(.init(x: bound.tapped.x, y: bound.tapped.y))
                                    }
                                }

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

                                Spacer()
                                
                                Text(pictures[current].name)
                                    .font(.custom("AutautGrotesk-Bold", size: 28))
                                    .lineSpacing(-0.28)
                                    .foregroundStyle(.white)
                                    .padding(.bottom, 8)
                                
                                Text(pictures[current].location)
                                    .font(.custom("AutautGrotesk-Medium", size: 14))
                                    .lineSpacing(-0.1)
                                    .foregroundStyle(.white)
                                    .padding(.bottom, 10)


                                HStack(spacing: 28) {
                                    Button {
                                        print("click book")
                                    } label: {
                                        HStack(spacing: 12) {
                                            Image(uiImage: .plus)
                                                .resizable()
                                                .frame(width: 10, height: 10)

                                            Text(pictures[current].type)
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
                            .opacity(isTextVisible ? 1 : 0)
                            .opacity(1 - interpolateValue(dragNextProgress, minValue: 0, maxValue: 1))
                            .onChange(of: self.current) {
                                withAnimation {
                                    isTextVisible = true
                                }
                            }
                        }
                        .blur(radius: interpolateValue(dragNextProgress * 0.75, minValue: 0, maxValue: 20))
                        .modifier(BrushImageModifierEffect(origin: initialPosition, dragProgress: dragNextProgress))
                        .modifier(BrushImageModifierEffectArr(bounds: arrBounds))
                    }
                  
                    
                    if hasNext {
                        let next = pictures[current + 1]
                        
                        Image(uiImage: next.image)
                            .resizable()
                            .scaledToFill()
                            .frame(
                                width: proxy.size.width, height: proxy.size.height + safeArea.bottom + safeArea.top
                            )
                            .scaleEffect(1.05)
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
                .onTapGesture { tappedLocation in
                    Task { @MainActor in
                        if let tappedSubject = await self.viewModel.interaction.subject(at: tappedLocation) {
                            let bound = Bound.init(tapped: tappedLocation, object: tappedSubject.bounds)
                            
                            if !arrBounds.contains(where: { $0.id == bound.id }) {
                                arrBounds.append(bound)
                            }
                        }
                    }
                }
                .gesture(drag(width: proxy.size.width, height: proxy.size.height))
            }
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ObjectDetector()
}
