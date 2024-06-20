//
//  ContentView.swift
//  animations-swift
//
//  Created by João Damazio on 15/06/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: RotationCarousel()) {
                    Text("Rotation Carousel")
                }
                NavigationLink(destination: ParallaxCarousel()) {
                    Text("Parallax Carousel")
                }
                NavigationLink(destination: ScrollViewWithVisualEffect()) {
                    Text("Scroll View Using Visual Effect")
                }
                NavigationLink(destination: MeshGradient()) {
                    Text("Mesh Gradient")
                }
                NavigationLink(destination: CustomTransition()) {
                    Text("Custom transition")
                }
                NavigationLink(destination: RippleEffect()) {
                    Text("Ripple Effect")
                }
                NavigationLink(destination: DotAnimations()) {
                    Text("Dot animation")
                }
//                NavigationLink(destination: RotationCard()) {
//                    Text("Rotation card")
//                }
            }
            .navigationBarHidden(true)
                        
        }
    }
}

#Preview {
    ContentView()
}
