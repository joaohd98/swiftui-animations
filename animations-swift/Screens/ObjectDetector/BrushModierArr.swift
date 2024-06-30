//
//  BrushModierArr.swift
//  animations-swift
//
//  Created by João Damazio on 29/06/24.
//

import Foundation

import SwiftUI

struct BrushImageModifierEffectArr: ViewModifier {
    var bounds: [Bound]
    var duration: TimeInterval { 2 }
    
    func body(content: Content) -> some View {
        
        content.keyframeAnimator(initialValue: 0, trigger: bounds.count) { view, elapsedTime in
            if let origin = bounds.last {
                view.modifier(
                    BrushImageModifier(
                        origin: origin.tapped,
                        elapsedTime: elapsedTime,
                        duration: duration
                    )
                )
            } else {
                view
            }
        } keyframes: { _ in
            MoveKeyframe(0)
            LinearKeyframe(duration, duration: duration)
        }
    }
}
