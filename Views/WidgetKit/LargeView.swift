//
//  Large.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import SwiftUI
import WidgetKit

struct Large: View {
    let entry: TimerEntry;
    
    var body: some View {
        VStack(alignment: .leading) {
            WidgetHeader(entry: entry)
            
            let pastSessions = entry.race.pastSessions
            let ongoingSessions = entry.race.ongoingSessions
            let futureSessions = entry.race.futureSessions
            
            ForEach(pastSessions, id: \.key) { session in
                SessionInfo(session: session.value)
            }
            
            ForEach(ongoingSessions, id: \.key) { session in
                SessionInfo(session: session.value)
            }
            
            ForEach(futureSessions, id: \.key) { session in
                SessionInfo(session: session.value)
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

