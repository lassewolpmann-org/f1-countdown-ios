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
            
            ForEach(entry.race.sortedSessions, id: \.key) { session in
                let name = session.key;
                let date = ISO8601DateFormatter().date(from: session.value)!

                SessionInfo(date: date, name: name, sessionLengths: entry.sessionLengths)
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
    TimerEntry(race: RaceData(), tbc: true, flag: "", sessionLengths: RaceData().sessionLengths)
}

