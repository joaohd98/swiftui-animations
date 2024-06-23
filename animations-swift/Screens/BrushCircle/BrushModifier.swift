//
//  BrushModifier.swift
//  animations-swift
//
//  Created by João Damazio on 23/06/24.
//

import SwiftUI

struct BrushModifier: ViewModifier {
    var origin: CGPoint
    var destination: CGPoint
    var elapsedTime: TimeInterval
    var duration: TimeInterval

    var amplitude: Double = 12
    var frequency: Double = 15
    var decay: Double = 8
    var speed: Double = 1200

    func body(content: Content) -> some View {
        let shader = ShaderLibrary.Brush(
            .float2(origin),
            .float2(destination),
            .float(elapsedTime),
            .float(amplitude),
            .float(frequency),
            .float(decay),
            .float(speed)
        )
        
        if(origin != .zero) {
            content.visualEffect { view, _ in
                view.layerEffect(
                    shader,
                    maxSampleOffset: maxSampleOffset,
                    isEnabled: 0 < elapsedTime && elapsedTime < duration
                )
            }
        } else {
            content
        }
    }
    
    var maxSampleOffset: CGSize {
        CGSize(width: amplitude, height: amplitude)
    }
}

struct BrushModifierEffect: ViewModifier {
    var origin: CGPoint
    var destination: CGPoint
    var duration: TimeInterval { 2 }
    
    func body(content: Content) -> some View {
        content.keyframeAnimator(initialValue: 0.0, trigger: origin) {
        [origin] view, elapsedTime in
            view.modifier(
                BrushModifier(
                    origin: origin,
                    destination: destination,
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
