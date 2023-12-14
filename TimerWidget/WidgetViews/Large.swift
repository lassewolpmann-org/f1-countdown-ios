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
            HStack {
                Text("\(entry.flag) \(entry.raceName) Grand Prix".uppercased())
                    .font(.headline)
                Spacer()
                Text(entry.tbc == true ? "TBC" : "")
            }
            
            ForEach(entry.sessions.sorted(by:{$0.value < $1.value}), id: \.key) { session in
                let name = session.key;
                let date = ISO8601DateFormatter().date(from: session.value)!

                SessionInfo(date: date, name: name, dividerPadding: 2.0, sessionLengths: entry.sessionLengths)
            }
        }.containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
        
}

#Preview {
    Large(entry: TimerEntry(date: Date(), raceName: RaceData().name, sessions: RaceData().sessions, tbc: false, flag: "", sessionLengths: APIConfig().sessionLengths))
}
