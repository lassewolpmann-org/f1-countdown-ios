//
//  Large.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import SwiftUI
import WidgetKit
import SwiftData

struct Large: View {
    @Query var allSeries: [SeriesData]
    
    var nextRace: RaceData? {
        let currentSeries = allSeries.first { $0.series == "f1" }
        let currentSeason = currentSeries?.seasons.first { $0.year == 2024 }
        return currentSeason?.races.first
    }
    
    let entry: TimerEntry;
    
    var body: some View {
        VStack(alignment: .leading) {
            WidgetHeader(entry: entry)
            
            let pastSessions = nextRace?.pastSessions ?? []
            let ongoingSessions = nextRace?.ongoingSessions ?? []
            let futureSessions = nextRace?.futureSessions ?? []
            
            ForEach(pastSessions, id: \.shortName) { session in
                SessionInfo(session: session)
            }
            
            ForEach(ongoingSessions, id: \.shortName) { session in
                SessionInfo(session: session)
            }
            
            ForEach(futureSessions, id: \.shortName) { session in
                SessionInfo(session: session)
            }
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
        
}

#Preview(as: .systemLarge) {
    TimerWidget()
} timeline: {
    TimerEntry(race: RaceData(), date: Date.now)
}

