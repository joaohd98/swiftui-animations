//
//  SquareMask.swift
//  animations-swift
//
//  Created by João Damazio on 22/06/24.
//

import SwiftUI
import CoreGraphics


struct SquareMask: View {
    var body: some View {
           GeometryReader { geometry in
               Path { path in
                   let limitY = geometry.size.height
                   let limitX = geometry.size.width
                   let midY = limitY / 2
                   let midX = limitX / 2
                   
                   path.move(to: CGPoint(x: 0, y: 0))
                   path.addLine(to: CGPoint(x: 0, y: 0))
                   path.addCurve(
                    to: .init(x: midX, y: 30),
                    control1: .init(x: midX, y: 0),
                    control2: .init(x: midX, y: 50)
                   )
                   path.addCurve(
                    to: .init(x: limitX, y: 0),
                    control1: .init(x: limitX, y: 0),
                    control2: .init(x: limitX, y: 0)
                   )

                   path.addLine(to: CGPoint(x: 0, y: limitY))
                   path.closeSubpath()
               }
               .fill(.black)
           }
       }
}

#Preview {
    SquareMask()
        .padding()
}
