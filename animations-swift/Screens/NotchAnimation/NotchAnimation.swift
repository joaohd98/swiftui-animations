//
//  NotchAnimation.swift
//  animations-swift
//
//  Created by João Damazio on 25/06/24.
//

import SwiftUI

struct NotchAnimation: View {
    @State var enterAnimation: Bool = false
    @State var visibleAnimation: Bool = false

    @Environment (\.colorScheme) private var colorScheme
 
    var body: some View {
        GeometryReader {
//            let size = $0.size
            let safeArea = $0.safeAreaInsets
            let hasDynamicIsland = safeArea.top > 51

            Group {
                VStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 32, height: 32)
                        .overlay {
                            Image(uiImage: .iaIcon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 16, height: 16)
                        }
                        .anchorPreference(key: AnchorKey.self, value: .bounds, transform: {
                            return ["header": $0]
                        })
                        .padding(.top, safeArea.top + 12)
                        .padding(.top, enterAnimation ? 0 : hasDynamicIsland ? -56 : -60)


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
                            enterAnimation = false
                            visibleAnimation = false

                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(.spring(duration: 0.8, bounce: 0.5)) {
                                    enterAnimation = true
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation(.linear(duration: 0.2)) {
                                        visibleAnimation = true
                                    }
                                }
                                
                            }
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
                    .padding(.bottom, 50)
                }
                .frame(maxWidth: .infinity)
                .overlayPreferenceValue(AnchorKey.self, { pref in
                    VStack {
                        GeometryReader { proxy in
                            if let anchor = pref["header"] {
                                let frameRect = proxy[anchor]
                                Canvas { out, size in
                                    out.addFilter(.alphaThreshold(min: 0.5))
                                    out.addFilter(.blur(radius: 12))
        
                                    out.drawLayer { ctx in
                                        if let circle = out.resolveSymbol(id: 0) {
                                            ctx.draw(circle, in: CGRect(
                                                x: frameRect.minX - 3.5,
                                                y: frameRect.minY - 3.5,
                                                width: frameRect.width + 6.5,
                                                height: frameRect.height + 6.5
                                            ))
                                        }
                                        
                                        if let dynamicIsland = out.resolveSymbol(id: 1) {
                                            let rect = CGRect(
                                                x: (size.width - 120) / 2,
                                                y: hasDynamicIsland ? 12 : -10,
                                                width: 120,
                                                height: 37
                                            )
        
                                           ctx.draw(dynamicIsland, in: rect)
                                        }
                                    }
                                } symbols: {
                                    Circle()
                                        .tag(0)
                                        .id(0)
                                        .transition(.opacity)
        
                                    RoundedRectangle(cornerRadius: 18)
                                        .tag(1)
                                        .id(1)
                                }
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    .opacity(visibleAnimation ? 0 : 1)
                })
            }
            .padding(.bottom, safeArea.bottom + 15)
            .background {
                Image(uiImage: .trunkHotel)
                    .resizable()
                    .scaledToFill()
            }
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NotchAnimation()
        .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
}
