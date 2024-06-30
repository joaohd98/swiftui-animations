//
//  BrushModifier.swift
//  animations-swift
//
//  Created by João Damazio on 23/06/24.
//

import SwiftUI

struct BrushImageModifier: ViewModifier {
    var origin: CGPoint
    var elapsedTime: TimeInterval
    var duration: TimeInterval

    var amplitude: Double = 12
    var frequency: Double = 15
    var decay: Double = 8
    var speed: Double = 1200

    var maxSampleOffset: CGSize {
       CGSize(width: amplitude, height: amplitude)
    }
    
    func body(content: Content) -> some View {
        let shader = ShaderLibrary.Brush(
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
}

struct BrushImageModifierEffect: ViewModifier {
    var origin: CGPoint
    var dragProgress: CGFloat
    var duration: TimeInterval { 1 }
    
    func body(content: Content) -> some View {
        content.keyframeAnimator(initialValue: 0.0, trigger: origin) {
        [origin] view, _ in
            view.modifier(
                BrushImageModifier(
                    origin: origin,
                    elapsedTime: mapRange(inMin: 0, inMax: 0.6, outMin: 0, outMax: 1, valueToMap: dragProgress),
                    duration: duration
                )
            )
        } keyframes: { _ in
            MoveKeyframe(0)
            LinearKeyframe(duration, duration: duration)
        }
    }
}

#Preview {
    BrushNotchAnimation()
}
