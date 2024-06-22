//
//  BrushAnimation.swift
//  animations-swift
//
//  Created by João Damazio on 20/06/24.
//

import SwiftUI
import AVKit


struct BrushAnimation: View {
    @State var origin: CGPoint = .zero
    @State var counter: Int = 0
    
    let blurRadius = 10.0
    let alphaThreshold = 0.2
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
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
                .mask {
                    Canvas { context, size in
                        let simbol = context.resolveSymbol(id: "square")!
                        
                        context.drawLayer { context2 in
                            context2
                                .draw(simbol, at: .init(
                                    x: size.width / 2,
                                    y: size.height / 2
                                )
                            )
                        }
                    } symbols: {
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 200, height: 200)
                            .tag("square")
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    BrushAnimation()
}
