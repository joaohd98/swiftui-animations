//
//  HourText.swift
//  animations-swift
//
//  Created by João Damazio on 16/06/24.
//

import SwiftUI
import Combine
import MulticolorGradient

class TimeViewModel: ObservableObject {
    @Published var currentTime: String = ""
    @Published var greeting: String = ""

    private var timer: AnyCancellable?

    init() {
        self.updateTimeAndGreeting()
        self.startTimer()
    }

    private func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.updateTimeAndGreeting()
            }
    }

    private func updateTimeAndGreeting() -> Void {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let now = Date()
        self.currentTime = dateFormatter.string(from: now)
        self.greeting = self.getGreeting(from: now)
    }
    
    private func getGreeting(from date: Date) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
            case 6..<12:
                return "Good\nMorning"
            case 12..<18:
                return "Good\nAfternoon"
            case 18..<22:
                return "Good\nEvening"
            default:
                return "Good\nNight"
        }
    }
}


struct HourText: View {
    @ObservedObject var viewModel = TimeViewModel()
    var isFullScreen: CGFloat

    var body: some View {
        VStack(spacing: 2) {
            Text(viewModel.currentTime)
                .font(.system(size: 18, weight: .medium, design: .monospaced))
                .opacity(isFullScreen)
            
            Text(viewModel.greeting.uppercased())
                .font(.system(size: 42, weight: .bold, design: .serif))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .opacity(0.7)
                .scaleEffect(interpolateValue(isFullScreen, minValue: 1, maxValue: 0.7))
            
        }
    }
}

#Preview {
    @State var isFullScreen = 1.0

    return ZStack {
        MulticolorGradient {
            ColorStop(position: .top, color: .dustStorm)
            ColorStop(position: .init(x: 0, y: 0.5), color: .middlePurple)
            ColorStop(position: .init(x: 1, y: 0.5), color: .pastelPink)
            ColorStop(position: .bottom, color: .dustStorm)
        }
        .edgesIgnoringSafeArea(.all)
        HourText(isFullScreen: isFullScreen)
    }
}
