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
        let firstSession = entry.race.futureSessions.first!;
        let name = firstSession.key;
        let date = ISO8601DateFormatter().date(from: firstSession.value)!
        
        VStack(alignment: .leading) {
            WidgetHeader(entry: entry)
            
            Divider()

            SessionInfo(date: date, name: name, sessionLengths: entry.sessionLengths)
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(race: RaceData(), tbc: true, flag: "", sessionLengths: DataConfig().sessionLengths)
}

