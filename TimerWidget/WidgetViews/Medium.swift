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
        VStack {
            VStack(alignment: .leading) {
                Text("\(entry.flag) \(entry.raceName) Grand Prix".uppercased())
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Text(parseSessionName(name: entry.sessionName))
                    .font(.title)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(getDayName(date: entry.sessionDate))
                    .foregroundStyle(.red)
                
                HStack {
                    Text(getOnlyDay(date: entry.sessionDate))
                        .font(.title)
                    Spacer()
                    Text("from \(getTime(date: entry.sessionDate))")
                        .font(.title)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .containerBackground(for: .widget) {
            VStack(spacing: 0) {
                Color(uiColor: .systemBackground)
                Color(uiColor: .secondarySystemBackground)
            }
        }
    }
}

#Preview {
    Medium(entry: TimerEntry(date: Date(), raceName: RaceData().name, sessions: RaceData().sessions, sessionDate: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, sessionName: "fp1", flag: ""))
}
