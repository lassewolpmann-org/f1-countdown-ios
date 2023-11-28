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
            Text("\(entry.flag) \(entry.raceName) Grand Prix".uppercased())
                .font(.headline)
            
            Divider()
                .padding([.top, .bottom], 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text(getDayName(date: entry.sessionDate))
                        .font(.subheadline)
                        .foregroundStyle(.red)
                    
                    Spacer()
                    
                    Text(parseSessionName(sessionName: entry.sessionName))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text(getOnlyDay(date: entry.sessionDate))
                        .font(.subheadline)
                    Spacer()
                    Text("from \(getTime(date: entry.sessionDate))")
                        .font(.subheadline)
                }
            }
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

#Preview {
    Medium(entry: TimerEntry(date: Date(), raceName: RaceData().name, sessions: RaceData().sessions, sessionDate: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, sessionName: "fp1", flag: ""))
}
