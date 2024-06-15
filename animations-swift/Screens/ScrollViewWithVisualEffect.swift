//
//  ScrollViewWithVisualEffect.swift
//  animations-swift
//
//  Created by João Damazio on 15/06/24.
//

import SwiftUI

struct ScrollViewWithVisualEffect: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 4) {
                ForEach(randomWords, id: \.self) { word in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.purple)
                        .frame(height: 100)
                        .overlay {
                            Text(word.uppercased())
                                .font(.largeTitle)
                                .padding()
                        }
                        .visualEffect { content, proxy in
                            content
                                .hueRotation(Angle(degrees: proxy.frame(in: .global).origin.y / 10))
                                .scaleEffect(max(min(proxy.frame(in: .global).origin.y / 40, 1), 0))
                                .opacity(max(min(proxy.frame(in: .global).origin.y / 60, 1), 0))
                        }
                   
                }
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ScrollViewWithVisualEffect()
}
