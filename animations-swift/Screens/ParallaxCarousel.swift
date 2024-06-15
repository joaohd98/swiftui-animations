//
//  ParallaxCarousel.swift
//  animations-swift
//
//  Created by João Damazio on 15/06/24.
//

import SwiftUI

struct ParallaxCarousel: View {
   
    @ViewBuilder
    func Photo(_ url: String, size: CGSize) -> some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .empty:
                    ProgressView()
                case .failure(_):
                    VStack {}
                @unknown default:
                    VStack {}
            }
        }
        .frame(width: size.width * 0.8, height: size.height / 2)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .clipped()
    }


    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: size.width * 0.05) {
                    ForEach(photos, id: \.self) { url in
                        VStack(spacing: 0) {
                            ZStack {
                                Photo(url, size: size)
                                    .scrollTransition(
                                        axis: .horizontal
                                    ) { content, phase in
                                        return content
                                            .offset(x: phase.value * -(size.width * 0.4))
                                    }
                            }
                            .containerRelativeFrame(.horizontal)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(size.width * 0.1)
            .scrollTargetBehavior(.paging)
        }
        .padding(.top, 70)
    }
}

#Preview {
    ParallaxCarousel()
}
