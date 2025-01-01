//
//  WidgetHeader.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 27.2.2024.
//

import SwiftUI
import WidgetKit
import SwiftData

struct WidgetHeader: View {
    let race: Season.Race
        
    var body: some View {
        HStack {
            Text(race.title)
                .font(.headline)
            
            Spacer()
        }
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(date: .now)
}
