//
//  Large.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import SwiftUI

struct Large: View {
    let entry: TimerEntry;
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(entry.flag) \(entry.raceName) Grand Prix".uppercased())
                .font(.headline)
            
            ForEach(entry.sessions.sorted(by:{$0.value < $1.value}), id: \.key) { session in
                let name = session.key;
                let date = ISO8601DateFormatter().date(from: session.value)!
                
                Divider()
                    .padding([.top, .bottom], 2)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(getDayName(date: date))
                            .font(.subheadline)
                            .foregroundStyle(.red)
                        
                        Spacer()
                        
                        Text(parseSessionName(sessionName: name))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text(getOnlyDay(date: date))
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("from \(getTime(date: date))")
                            .font(.subheadline)
                    }
                }
            }
        }.containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
        
}

#Preview {
    Large(entry: TimerEntry(date: Date(), raceName: RaceData().name, sessions: RaceData().sessions, sessionDate: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, sessionName: "fp1", flag: ""))
}
