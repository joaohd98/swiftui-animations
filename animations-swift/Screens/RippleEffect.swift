//
//  RippleEffect.swift
//  animations-swift
//
//  Created by João Damazio on 15/06/24.
//

import SwiftUI

struct RippleModifier: ViewModifier {
    var origin: CGPoint
    var elapsedTime: TimeInterval
    var duration: TimeInterval

    var amplitude: Double = 12
    var frequency: Double = 15
    var decay: Double = 8
    var speed: Double = 1200

    func body(content: Content) -> some View {
        let shader = ShaderLibrary.Ripple(
            .float2(origin),
            .float(elapsedTime),
            .float(amplitude),
            .float(frequency),
            .float(decay),
            .float(speed)
        )
        
        content.visualEffect { view, _ in
            view.layerEffect(
                shader,
                maxSampleOffset: maxSampleOffset,
                isEnabled: 0 < elapsedTime && elapsedTime < duration
            )
        }
    }
    
    var maxSampleOffset: CGSize {
        CGSize(width: amplitude, height: amplitude)
    }
}

struct RippleModifierEffect<T: Equatable>: ViewModifier {
    var trigger: T
    var origin: CGPoint
    var duration: TimeInterval { 3 }
    
    func body(content: Content) -> some View {
        content.keyframeAnimator(initialValue: 0.0, trigger: trigger) {
        [origin] view, elapsedTime in
            view.modifier(
                RippleModifier(
                    origin: origin,
                    elapsedTime: elapsedTime,
                    duration: duration
                )
            )
        } keyframes: { _ in
            MoveKeyframe(0)
            LinearKeyframe(duration, duration: duration)
        }
    }
}

struct RippleEffect: View {
    @State var origin: CGPoint = .zero
    @State var counter: Int = 0

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                                        
                    Image(uiImage: .palmTree)
                        .resizable()
                        .scaledToFill()
                        .modifier(RippleModifierEffect(trigger: counter, origin: origin))
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                        .clipShape(.rect(cornerRadius: 14))
                        .onTapGesture {
                            origin = $0
                            counter += 1
                            print(origin)
                        }
                    
                    
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    RippleEffect()
}
