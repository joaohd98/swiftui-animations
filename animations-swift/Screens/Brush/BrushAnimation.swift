//
//  BrushAnimation.swift
//  animations-swift
//
//  Created by João Damazio on 20/06/24.
//

import SwiftUI
import AVKit

struct BrushAnimation: View {
    let video: URL
    let avPlayer: AVPlayer
    
    init() {
        self.video = Bundle.main.url(forResource: "new-york", withExtension: "mp4")!
        self.avPlayer = AVPlayer(url: video)
        self.avPlayer.isMuted = true
    }
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                VideoPlayer(player: avPlayer)
                    .aspectRatio(contentMode: .fill)
                    .disabled(true)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .onAppear {
                        avPlayer.play()
                    }
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
            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    BrushAnimation()
}
