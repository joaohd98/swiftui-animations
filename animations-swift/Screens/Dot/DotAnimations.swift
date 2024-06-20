//
//  Dot.swift
//  animations-swift
//
//  Created by João Damazio on 16/06/24.
//

import SwiftUI
import MulticolorGradient


let views = [
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning",
    "good-morning"
]

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: [Int: CGFloat] = [:]

    static func reduce(value: inout [Int: CGFloat], nextValue: () -> [Int: CGFloat]) {
        let newValue = nextValue()

        for (key, val) in newValue {
            if let existingValue = value[key] {
                value[key] = existingValue + val
            } else {
                value[key] = val
            }
        }
    }
}


struct DotAnimations: View {
    @State var current = -1
    @State var isFullScreenFloat = 0.0
    @State var isFullScreen = false
    @State var offsetY: [Int: CGFloat] = [:]
    
    func calculateYOffset(index: Int, height: CGFloat) -> CGFloat {
        guard let currentOffsetY = offsetY[current] else { return 0 }
        var yValue = interpolateValue(isFullScreenFloat, minValue: 0, maxValue: abs(currentOffsetY))
        yValue = currentOffsetY > 0 ? -yValue : yValue
                
        if current > index {
            let percentage = offsetY[index].map { ($0 / height) * 0.3} ?? 0
            return yValue * (1.3 - percentage)
        }
        
        if current < index {
            return yValue * 0.9
        }
        
        return yValue
    }
    
    func calculateBlur(index: Int) -> CGFloat {
        if index != current {
            return interpolateValue(isFullScreenFloat, minValue: 0, maxValue: 30)
        }
        
        return 0
    }
    
    func calculateOpacity(index: Int) -> CGFloat {
        if !isFullScreen {
            return 1
        }
        
        if index != current {
            return 1 - interpolateValue(isFullScreenFloat, minValue: 0, maxValue: 1)
        }
        
        return 1
    }
 
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(Array(views.enumerated()), id: \.offset) { index, view in
                            
                            if view == "good-morning" {
                                GoodMorning(isFullScreen: current == index ? isFullScreenFloat : 0, proxy: proxy)
                                   .onTapGesture {
                                       current = index
                                       
                                       withAnimation(.spring(duration: 0.7, bounce: 0.4)) {
                                           isFullScreenFloat = 1
                                           isFullScreen = true
                                       }
                                   }
                                   .overlay {
                                       GeometryReader {
                                           let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
                                           
                                           Color
                                               .clear
                                               .preference(key: ViewOffsetKey.self, value: [index: minY])
                                               .onPreferenceChange(ViewOffsetKey.self, perform: { value in
                                                   if !isFullScreen {
                                                       for (key, val) in value {
                                                           offsetY[key] = val
                                                       }
                                                   }
                                               })
                                       }
                                   }
                                   .offset(y: calculateYOffset(index: index, height: proxy.size.height))
                                   .blur(radius: calculateBlur(index: index))
                                   .opacity(calculateOpacity(index: index))
                               }
                            }
                        }
                    }
                .disabled(isFullScreen)

                VStack {
                    Spacer()
                    
                    BottomInput()
                        .opacity(isFullScreenFloat)
                }
            }
            .gesture(
                MagnifyGesture()
                    .onChanged { action in
                        if !isFullScreen {
                            return
                        }
                        
                        isFullScreenFloat = action.magnification + 0.05
                    }
                    .onEnded { action in
                        let bounce = mapRange(
                            inMin: 0,
                            inMax: 15,
                            outMin: 0.1,
                            outMax: 0.4,
                            valueToMap: -action.velocity
                        )
                        
                        withAnimation(.spring(duration: 0.7, bounce: bounce)) {
                            if !isFullScreen {
                                return
                            }

                            isFullScreenFloat = isFullScreenFloat > 0.9 ? 1 : 0
                        } completion: {
                            if isFullScreenFloat == 0 {
                                isFullScreen = false
                                current = -1
                            }
                        }
                    }
            )
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    DotAnimations()
}
