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
    let name: String
    let height: CGFloat
    let width: CGFloat
    
    var body: some View {
        Color.white
            .frame(width: self.width, height: self.height)
            .overlay {
                let video = Bundle.main.url(forResource: self.name, withExtension: "mp4")!
                let avPlayer = AVPlayer(url: video)
                avPlayer.isMuted = true
                avPlayer.play()
                
                return VideoPlayer(player: avPlayer)
                    .aspectRatio(contentMode: .fill)
                    .disabled(true)
                    .onReceive(
                        NotificationCenter
                            .default
                            .publisher(
                                for: .AVPlayerItemDidPlayToEndTime,
                                object: avPlayer.currentItem),
                                   perform: { _ in
                                       avPlayer.seek(to: .zero)
                                       avPlayer.play()
                                    }
                    )
            }
       
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
