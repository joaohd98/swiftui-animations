//
//  Shine.swift
//  animations-swift
//
//  Created by João Damazio on 30/06/24.
//

import Foundation
import SwiftUI

struct ShineModifier: ViewModifier {
    @State var moveGradient = false
    var duration: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let moddedDuration = max(0.3, duration)
                    let widthAdd = size.width + size.width * 0.3
                    
                    Rectangle()
                        .fill(LinearGradient(
                            colors: [
                                .clear,
                                .clear,
                                .white.opacity(0.3),
                                .white.opacity(0.4),
                                .white.opacity(0.4),
                                .white.opacity(0.3),
                                .clear,
                                .clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .keyframeAnimator(initialValue: 0.0, trigger: moveGradient, content: { content, progress in
                            content
                                .offset(x: -widthAdd + (progress * (widthAdd * 2)))
                        }, keyframes: { _ in
                            CubicKeyframe(.zero, duration: 0)
                            CubicKeyframe(1, duration: moddedDuration)
                        })
                        .scaleEffect(x: moveGradient ? 1 : -1)
                        .rotationEffect(.init(degrees: 230))
                        .frame(width: size.width * 0.3)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: moddedDuration, repeats: true) { _ in
                                moveGradient.toggle()
                            }
                        }
                }
            }
            .clipShape(.rect)
    }
}

extension View {
    @ViewBuilder
    func shine(duration: CGFloat = 0.8) -> some View {
        self.modifier(ShineModifier(duration: duration))
    }
}

#Preview {
    ObjectDetector()
}

