//
//  Medium.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import SwiftUI
import WidgetKit
import SwiftData

struct Medium: View {
    @Query var allSeries: [SeriesData]
    
    var nextRace: RaceData? {
        let currentSeries = allSeries.first { $0.series == "f1" }
        let currentSeason = currentSeries?.seasons.first { $0.year == 2024 }
        return currentSeason?.races.first
    }
    
    let entry: TimerEntry;
    
    var body: some View {
        if let session = nextRace?.futureSessions.first {
            VStack(alignment: .leading) {
                WidgetHeader(entry: entry)
                SessionInfo(session: session)
            }
            .containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        } else if let session = nextRace?.ongoingSessions.first {
            VStack(alignment: .leading) {
                WidgetHeader(entry: entry)
                SessionInfo(session: session)
            }
            .containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        } else if let session = nextRace?.sessions.last {
            VStack(alignment: .leading) {
                WidgetHeader(entry: entry)
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
    TimerEntry(race: RaceData(), date: Date.now)
}

