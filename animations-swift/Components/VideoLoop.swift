//
//  VideoPlayer.swift
//  animations-swift
//
//  Created by João Damazio on 22/06/24.
//

import SwiftUI
import AVFoundation
import AVKit

struct VideoLoop: View {
    let height: CGFloat
    let width: CGFloat
    
    private let video: URL
    private let avPlayer: AVPlayer
    
    private let blurRadius = 10.0
    private let alphaThreshold = 0.2
    
    init(name: String, height: CGFloat,  width: CGFloat) {
        self.height = height
        self.width = width

        self.video = Bundle.main.url(forResource: name, withExtension: "mp4")!
        self.avPlayer = AVPlayer(url: video)
        self.avPlayer.isMuted = true
    }
    
    var body: some View {
        VideoPlayer(player: avPlayer)
            .aspectRatio(contentMode: .fill)
            .disabled(true)
            .onAppear {
                avPlayer.play()
            }
            .frame(width: self.width, height: self.height)
            .onReceive(
                NotificationCenter
                    .default
                    .publisher(
                        for: .AVPlayerItemDidPlayToEndTime,
                        object: self.avPlayer.currentItem),
                           perform: { _ in
                               self.avPlayer.seek(to: .zero)
                               self.avPlayer.play()
                            }
            )
            .clipped()
    }
}

#Preview {
    GeometryReader { geometry in
        VideoLoop(
            name: "new-york",
            height: geometry.size.height,
            width: geometry.size.width
        )
    }
    .ignoresSafeArea()
}
