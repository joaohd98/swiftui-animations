//
//  Dot.swift
//  animations-swift
//
//  Created by João Damazio on 16/06/24.
//

import SwiftUI
import MulticolorGradient


extension Color {
    static let dustStorm =  Color(
        UIColor(red: 226/255, green: 206/255, blue: 207/255, alpha: 1.0)
    )

    static let middlePurple =  Color(
        UIColor(red: 199/255, green: 132/255, blue: 183/255, alpha: 1.0)
    )

    static let pastelPink =  Color(
        UIColor(red: 229/255, green: 180/255, blue: 160/255, alpha: 1.0)
    )
}

struct GoodMorning: View {
    var isFullScreen: Bool
    var proxy: GeometryProxy
    
    var body: some View {
        MulticolorGradient {
            ColorStop(position: .top, color: .dustStorm)
            ColorStop(position: .init(x: 0, y: 0.5), color: .middlePurple)
            ColorStop(position: .init(x: 1, y: 0.5), color: .pastelPink)
            ColorStop(position: .bottom, color: .dustStorm)
        }
        .clipShape(.rect(cornerRadius: isFullScreen ? 0 : 32))
        .padding(.top, isFullScreen ? -proxy.safeAreaInsets.top : 0)
        .frame(height: isFullScreen ? proxy.size.height + proxy.safeAreaInsets.bottom : 280)
        .overlay {
            VStack {
                HourText(isFullScreen: isFullScreen)
                    .padding(.top, isFullScreen ? 0 : 16)

                
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 24) {
                            Text("I thrive in news enviromnets and welcome the adventures of learning.")
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
                        .rotationEffect(.degrees(isFullScreen ? -1 : -2))
                        .shadow(radius: 24)
                        
                        Spacer()
                    }
                    .padding(.top, isFullScreen ? 0 : 60)
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
                        .rotationEffect(.degrees(isFullScreen ? 2 : 2))
                        .shadow(radius: 24)
                    }
                    .padding(.trailing, 26)
                    .padding(.top, isFullScreen ? -125 : -240)
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
                    .padding(.top, isFullScreen ? -40 : -225)
                    .padding(.leading, isFullScreen ? 40 : 120)
                }
                .padding(.bottom, isFullScreen ? 0 : -400)
                
                Spacer()
            }
            .clipped()
        }
    }
}

struct DotAnimations: View {
    @State var currrent: Int? = 0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ScrollView {
                    VStack(spacing: 10) {
                        GoodMorning(isFullScreen: currrent == 0, proxy: proxy)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    currrent = 0
                                }
                            }
                    }
                }
                .disabled(currrent != nil)

                VStack {
                    Spacer()
                    
                    if currrent != nil {
                        BottomInput()
                    }
                }
            }
            .gesture(
                MagnifyGesture()
                    .onEnded { _ in
                        withAnimation(.spring) {
                            currrent = nil
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
