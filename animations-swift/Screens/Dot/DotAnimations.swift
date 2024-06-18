//
//  Dot.swift
//  animations-swift
//
//  Created by João Damazio on 16/06/24.
//

import SwiftUI
import MulticolorGradient


let views = [
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning"
]

struct DotAnimations: View {
    @State var current = 0
    @State var isFullScreenFloat = 1.0
    @State var isFullScreen = true
    @State var offsetY = 0.0
 
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(Array(views.enumerated()), id: \.offset) { index, view in
                            if view == "good-morning" {
                                GoodMorning(isFullScreen: current == index ? isFullScreenFloat : 0, proxy: proxy)
                                   .onTapGesture {
                                       current = index
                                       
                                       withAnimation(.spring) {
                                           isFullScreenFloat = 1
                                           isFullScreen = true
                                       }
                                   }
                            }
                        }
                    }
                }
                .disabled(isFullScreen)

                VStack {
                    Spacer()
                    
                    BottomInput()
                        .opacity(isFullScreenFloat)
                }
            }
            .gesture(
                MagnifyGesture()
                    .onChanged { action in
                        if !isFullScreen {
                            return
                        }
                        
                        isFullScreenFloat = action.magnification + 0.05
                    }
                    .onEnded { _ in
                        withAnimation(.spring) {
                            if !isFullScreen {
                                return
                            }

                            isFullScreenFloat = isFullScreenFloat > 0.9 ? 1 : 0
                        } completion: {
                            if isFullScreenFloat == 0 {
                                isFullScreen = false
                                current = -1
                            }
                        }
                    }
            )
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    DotAnimations()
}
