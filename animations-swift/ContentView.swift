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
                NavigationLink(destination: BrushVideo()) {
                    Text("Brush Video Animation")
                }
                NavigationLink(destination: BrushTouchAnimation()) {
                    Text("Brush Touch animation")
                }
                NavigationLink(destination: BrushImage()) {
                    Text("Brush image animation")
                }
                NavigationLink(destination: BrushImageFloat()) {
                    Text("Brush image Float animation")
                }
                NavigationLink(destination: NotchAnimation()) {
                    Text("Notch Animation")
                }
            }
            .navigationBarHidden(true)
                        
        }
    }
}

#Preview {
    ContentView()
}
