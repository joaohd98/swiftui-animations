//
//  GoodMorningView.swift
//  animations-swift
//
//  Created by João Damazio on 17/06/24.
//

import SwiftUI
import MulticolorGradient


struct GoodMorning: View {
    var isFullScreen: CGFloat
    var proxy: GeometryProxy
    
    var body: some View {
        MulticolorGradient {
            ColorStop(position: .top, color: .dustStorm)
            ColorStop(position: .init(x: 0, y: 0.5), color: .middlePurple)
            ColorStop(position: .init(x: 1, y: 0.5), color: .pastelPink)
            ColorStop(position: .bottom, color: .dustStorm)
        }
        .clipShape(.rect(cornerRadius: interpolateValue(isFullScreen, minValue: 32, maxValue: 0)))
        .padding(.top, -interpolateValue(isFullScreen, minValue: 0, maxValue: proxy.safeAreaInsets.top))
        .frame(height: interpolateValue(isFullScreen, minValue: 280, maxValue: proxy.size.height + proxy.safeAreaInsets.bottom))
        .overlay {
            VStack {
                HourText(isFullScreen: isFullScreen)
                    .padding(.top, interpolateValue(isFullScreen, minValue: 16, maxValue: 0))
                
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("I thrive in news environments and welcome the adventures of learning.")
                                .font(.system(size: 18, weight: .medium))
                            Text("Daily Afternoon")
                                .font(.system(size: 16, weight: .light))
                                .opacity(0.8)
                        }
                        .frame(width: 130, alignment: .leading)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 24)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 20))
                        .rotationEffect(.degrees(interpolateValue(isFullScreen, minValue: -2, maxValue: -1)))
                        .shadow(radius: 24)
                        
                        Spacer()
                    }
                    .padding(.leading, 40)
                    
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Image(uiImage: .building)
                                .resizable()
                                .clipped()
                                .overlay(Color.black.opacity(0.3))
                            
                            VStack {
                                Spacer()
                                Text("Vivian's birthday is coming up! Have you thought of a present?")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 12)
                                    .padding(.horizontal, 12)
                                
                            }
                        }
                        .frame(width: 170, height: 250)
                        .clipShape(.rect(cornerRadius: 12))
                        .rotationEffect(.degrees(2))
                        .shadow(radius: 24)
                    }
                    .padding(.trailing, 26)
                    .padding(.top, interpolateValue(isFullScreen, minValue: -240, maxValue: -125))
                    .zIndex(1)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            MonthDayText()
                            
                            Text("Daily Overview")
                                .font(.system(size: 16, weight: .light))
                                .opacity(0.8)
                        }
                        .frame(width: 130, alignment: .leading)
                        .padding(.vertical, 20)
                        .padding(.horizontal, 24)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 20))
                        .rotationEffect(.degrees(-0.5))
                        .shadow(radius: 24)
                        
                        Spacer()
                    }
                    .padding(.top, interpolateValue(isFullScreen, minValue: -225, maxValue: -40))
                    .padding(.leading, interpolateValue(isFullScreen, minValue: 120, maxValue: 40))
                }
                .padding(.bottom, interpolateValue(isFullScreen, minValue: -400, maxValue: 0))
                
                Spacer()
            }
            .clipped()
        }
    }
}

#Preview {
    GeometryReader { proxy in
        GoodMorning(isFullScreen: 1, proxy: proxy)
    }
}
