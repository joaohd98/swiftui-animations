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
                NavigationLink(destination: ObjectDetector()) {
                    Text("Objector detector")
                }
                NavigationLink(destination: BrushNotchAnimation()) {
                    Text("Brush Notch Animation")
                }
                NavigationLink(destination: NotchAnimation()) {
                    Text("Notch Animation")
                }
                NavigationLink(destination: BrushImageFloat()) {
                    Text("Brush image Float animation")
                }
                NavigationLink(destination: BrushImage()) {
                    Text("Brush image animation")
                }
                NavigationLink(destination: BrushTouchAnimation()) {
                    Text("Brush Touch animation")
                }
                NavigationLink(destination: BrushVideo()) {
                    Text("Brush Video Animation")
                }
                NavigationLink(destination: DotAnimations()) {
                    Text("Dot animation")
                }
                NavigationLink(destination: RippleEffect()) {
                    Text("Ripple Effect")
                }
                NavigationLink(destination: CustomTransition()) {
                    Text("Custom transition")
                }
                NavigationLink(destination: MeshGradient()) {
                    Text("Mesh Gradient")
                }
                NavigationLink(destination: ScrollViewWithVisualEffect()) {
                    Text("Scroll View Using Visual Effect")
                }
                NavigationLink(destination: ParallaxCarousel()) {
                    Text("Parallax Carousel")
                }
                NavigationLink(destination: RotationCarousel()) {
                    Text("Rotation Carousel")
                }

            }
            .navigationBarHidden(true)
                        
        }
    }
}

#Preview {
    ContentView()
}
