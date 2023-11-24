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
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("\(entry.flag) \(entry.raceName) Grand Prix".uppercased())
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Text(parseSessionName(name: entry.sessionName))
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Divider()
            
            VStack(alignment: .leading) {
                Text(getDayName(date: entry.sessionDate))
                    .font(.subheadline)
                    .foregroundStyle(.red)
                
                HStack {
                    Text(getOnlyDay(date: entry.sessionDate))
                        .font(.headline)
                    Spacer()
                    Text("from \(getTime(date: entry.sessionDate))")
                        .font(.headline)
                }
            }
        }
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

#Preview {
    Medium(entry: TimerEntry(date: Date(), raceName: RaceData().name, sessions: RaceData().sessions, sessionDate: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, sessionName: "fp1", flag: ""))
}
