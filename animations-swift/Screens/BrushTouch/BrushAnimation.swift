//
//  BrushAnimation.swift
//  animations-swift
//
//  Created by João Damazio on 20/06/24.
//

import SwiftUI
import AVKit

struct BrushTouchAnimation: View {
    @State var origin: CGPoint = .zero
    @State var counter: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                VideoLoop(
                    name: "new-york",
                    height: proxy.size.height,
                    width: proxy.size.width
                )
         
                VideoLoop(
                    name: "grand-canal",
                    height: proxy.size.height,
                    width: proxy.size.width
                )
                
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.1)
                    .modifier(RippleModifierEffect(trigger: counter, origin: origin))
                    .onTapGesture {
                        origin = $0
                        counter += 1
                    }
            }
        }
        .ignoresSafeArea(.all)
        .navigationBarHidden(true)
    }
}

#Preview {
    BrushTouchAnimation()
}
