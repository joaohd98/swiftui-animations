//
//  CustomTransition.swift
//  animations-swift
//
//  Created by João Damazio on 15/06/24.
//

import SwiftUI

struct Twirl: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .scaleEffect(phase.isIdentity ? 1 : 0.5)
            .opacity(phase.isIdentity ? 1 : 0)
            .blur(radius: phase.isIdentity ? 0 : 10)
            .rotationEffect(
                .degrees(
                    phase == .willAppear ? 360 :
                        phase == .didDisappear ? -360 : .zero
                )
            )
            .brightness(phase == .willAppear ? 1 : 0)
    }
}

struct CustomTransition: View {
    @State private var isVisible = true

    var body: some View {
        ZStack {
            VStack {
                if isVisible {
                    Image(systemName: "sun.max.fill")
                        .resizable()
                        .renderingMode(.original)
                        .imageScale(.large)
                        .transition(Twirl())
                }
            }
            .frame(width: 140, height: 140)
        }
        .overlay {
            Button(isVisible ? "Hide" : "Show") {
                withAnimation {
                    isVisible = !isVisible
                }
            }
            .padding(.top, 270)
        }
        
     
    }
}

#Preview {
    CustomTransition()
}
