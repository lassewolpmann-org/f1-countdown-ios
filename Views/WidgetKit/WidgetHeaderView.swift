//
//  WidgetHeader.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 27.2.2024.
//

import SwiftUI
import WidgetKit

struct WidgetHeader: View {
    let entry: TimerEntry;
    
    var body: some View {
        HStack {
            Text(entry.race.title)
                .font(.headline)
            Spacer()
            
            if (entry.race.tbc ?? false) {
                Text("TBC")
                    .font(.headline)
            }
        }
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(race: RaceData(), date: Date.now)
}
