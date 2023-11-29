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
        let firstSession = entry.sessions.first ?? RaceData().sessions.first!;
        let name = firstSession.key;
        let date = ISO8601DateFormatter().date(from: firstSession.value)!
        
        VStack(alignment: .leading) {
            Text("\(entry.flag) \(entry.raceName) Grand Prix".uppercased())
                .font(.headline)

            SessionInfo(date: date, name: name, dividerPadding: 10.0, sessionLengths: entry.sessionLengths)
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

#Preview {
    Medium(entry: TimerEntry(date: Date(), raceName: RaceData().name, sessions: RaceData().sessions, flag: "", sessionLengths: APIConfig().sessionLengths))
}
