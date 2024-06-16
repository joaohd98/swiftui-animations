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

struct DotAnimations: View {
    var body: some View {
        ZStack {
            MulticolorGradient {
                ColorStop(position: .top, color: .dustStorm)
                ColorStop(position: .init(x: 0, y: 0.5), color: .middlePurple)
                ColorStop(position: .init(x: 1, y: 0.5), color: .pastelPink)
                ColorStop(position: .bottom, color: .dustStorm)
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                HourText()
                    .padding(.top, 20)
                
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
                    .rotationEffect(.degrees(-2))
                    .shadow(radius: 24)

                    Spacer()
                }
                .padding(.top, -20)
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
                .padding(.top, -120)
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
                .padding(.top, -60)
                .padding(.leading, 40)
                
                Spacer()
                
                BottomInput()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    DotAnimations()
}
