//
//  Medium.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import SwiftUI
import WidgetKit

struct Medium: View {
    let race: Season.Race

    var body: some View {
        if let session = race.futureSessions.first {
            VStack(alignment: .leading) {
                WidgetHeader(race: race)
                SessionInfo(session: session)
            }
            .containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        } else if let session = race.ongoingSessions.first {
            VStack(alignment: .leading) {
                WidgetHeader(race: race)
                SessionInfo(session: session)
            }
            .containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        } else if let session = race.sessions.last {
            VStack(alignment: .leading) {
                WidgetHeader(race: race)
                SessionInfo(session: session)
            }
            .containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        } else {
            Text("No sessions available to display.")
        }
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(date: Date.now)
}

