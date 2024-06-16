//
//  HourText.swift
//  animations-swift
//
//  Created by João Damazio on 16/06/24.
//

import SwiftUI
import Combine
import MulticolorGradient

class MonthDayViewModel: ObservableObject {
    @Published var dayWeek: String = ""
    @Published var month: String = ""

    private var timer: AnyCancellable?

    init() {
        self.updateMonthDay()
        self.startTimer()
    }

    private func startTimer() {
        self.timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.updateMonthDay()
            }
    }

    private func updateMonthDay() -> Void {
        let dateFormatterWeek = DateFormatter()
        dateFormatterWeek.dateFormat = "EEEE"
        
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.dateFormat = "MMM d"
        
        let now = Date()
        self.dayWeek = dateFormatterWeek.string(from: now)
        self.month = dateFormatterMonth.string(from: now)
    }
}

struct MonthDayText: View {
    @ObservedObject var viewModel = MonthDayViewModel()

   var body: some View {
       VStack(alignment: .leading, spacing: -2) {
           Text(viewModel.dayWeek)
               .font(.system(size: 32, weight: .bold))
               .lineLimit(1)
               .minimumScaleFactor(0.5)
           
           Text(viewModel.month)
               .font(.system(size: 30, weight: .semibold))
               .foregroundColor(.purple)
               .padding(.bottom, 50)
       }
   }
}

#Preview {
    MonthDayText()
}
