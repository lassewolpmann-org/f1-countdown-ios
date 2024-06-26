//
//  Medium.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import SwiftUI
import WidgetKit

struct Medium: View {
    let entry: TimerEntry;
    
    var body: some View {
        if let session = entry.race.futureSessions.first?.value {
            VStack(alignment: .leading) {
                WidgetHeader(entry: entry)
                SessionInfo(session: session)
            }
            .containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        } else {
            Text("No sessions")
        }
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(race: RaceData(), date: Date.now)
}

