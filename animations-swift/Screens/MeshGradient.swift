//
//  MeshGradient.swift
//  animations-swift
//
//  Created by João Damazio on 15/06/24.
//

import SwiftUI
import MulticolorGradient

enum Position: Int {
    case top = 0, center = 1, bottom = 2
}

struct MeshGradient: View {
    @State private var position = Position.top
    @State private var bgColor = [Color.red, Color.blue, Color.green]
    @State private var x = [0, 0.5, 1]
    @State private var y = [0, 0.5, 1]

    var body: some View {
        VStack {
            MulticolorGradient {
                ColorStop(position: .init(x: x[0], y: y[0]), color: bgColor[0])
                ColorStop(position: .init(x: x[1], y: y[1]), color: bgColor[1])
                ColorStop(position: .init(x: x[2], y: y[2]), color: bgColor[2])
            }
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    Button("Top") {
                        position = .top
                    }
                    
                    Spacer()
                    Button("Center") {
                        position = .center
                    }
                    Spacer()
                    Button("Botom") {
                        position = .bottom
                    }
                    Spacer()
                }
                ColorPicker("Color", selection: $bgColor[position.rawValue])
                HStack(spacing: 14) {
                    Text("X")
                    Slider(value: $x[position.rawValue], in: 0...1)
                }
                HStack(spacing: 14) {
                    Text("Y")
                    Slider(value: $y[position.rawValue], in: 0...1)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

#Preview {
    MeshGradient()
}
