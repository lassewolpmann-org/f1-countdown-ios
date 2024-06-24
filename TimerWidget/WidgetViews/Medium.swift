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
        if let firstSession = entry.sessions.first {
            VStack(alignment: .leading) {
                WidgetHeader(entry: entry)
                SessionInfo(session: firstSession)
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
    TimerEntry(sessions: [], name: "", tbc: true, flag: "")
}

