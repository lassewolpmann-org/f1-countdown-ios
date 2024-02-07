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
            HStack {
                Text(getRaceTitle(race: entry.race))
                    .font(.headline)
                Spacer()
                Text(entry.tbc == true ? "TBC" : "")
            }
            
            Divider()

            SessionInfo(date: date, name: name, sessionLengths: entry.sessionLengths)
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

#Preview {
    Medium(entry: TimerEntry(race: RaceData(), tbc: false, flag: "", sessionLengths: DataConfig().sessionLengths))
}
