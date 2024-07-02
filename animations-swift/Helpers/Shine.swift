//
//  Shine.swift
//  animations-swift
//
//  Created by João Damazio on 30/06/24.
//

import Foundation
import SwiftUI

struct ShineModifier: ViewModifier {
    var timeline: TimelineViewDefaultContext
    
    @State private var startTime = Date.now
    let duration: CGFloat = 1.5
    let gradientWidth: CGFloat = 0.2
    let maxLightness: CGFloat = 0.1
    
    func body(content: Content) -> some View {
        let elapsedTime = startTime.distance(to: timeline.date)

        content.visualEffect { content, proxy in
            content
                .colorEffect(
                    ShaderLibrary.shimmer(
                        .float2(proxy.size),
                        .float(elapsedTime),
                        .float(duration),
                        .float(gradientWidth),
                        .float(maxLightness)
                    )
                )
        }
    }
}

extension View {
    @ViewBuilder
    func shine() -> some View {
        TimelineView(.animation) { timeline in
            self.modifier(ShineModifier(timeline: timeline))
        }
    }
}

#Preview {
    ObjectDetector()
}

