//
//  NotchAnimation.swift
//  animations-swift
//
//  Created by João Damazio on 25/06/24.
//

import SwiftUI

struct NotchAnimation: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            VStack {
                Image(uiImage: .iaIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .padding(12)
                    .background(Color.white.opacity(0.12))
                    .clipShape(.circle)
          
                Spacer()
                
                Text("Trunk Hotel")
                    .font(.custom("AutautGrotesk-Bold", size: 28))
                    .lineSpacing(-0.28)
                    .foregroundStyle(.white)
                    .padding(.bottom, 8)
                
                Text("Tokyo, Japan")
                    .font(.custom("AutautGrotesk-Medium", size: 14))
                    .lineSpacing(-0.1)
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)


                HStack(spacing: 28) {
                    Button {
                        print("click plus")
                    } label: {
                        HStack(spacing: 12) {
                            Image(uiImage: .plus)
                                .resizable()
                                .frame(width: 10, height: 10)
                    
                            Text("Book")
                                .foregroundStyle(.black)
                                .font(.custom("AutautGrotesk-Semibold", size: 14))
                                .lineSpacing(-0.1)

                        }
                        .frame(width: 94, height: 40)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                 
                    
                    Button {
                        print("click three dots")
                    } label: {
                        Image(uiImage: .threeDots)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .background {
                                Color.black.opacity(0.2)
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                    }
                  
                }
                .padding(.bottom, 70)

            }
            .frame(width: size.width, height: size.height)
            .background {
                Image(uiImage: .trunkHotel)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    NotchAnimation()
}
