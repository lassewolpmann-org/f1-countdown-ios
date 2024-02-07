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
                Text(getRaceTitle(race: entry.race))
                    .font(.headline)
                Spacer()
                Text(entry.tbc == true ? "TBC" : "")
            }
            
            Divider()
            
            ForEach(entry.race.sortedSessions, id: \.key) { session in
                let name = session.key;
                let date = ISO8601DateFormatter().date(from: session.value)!

                SessionInfo(date: date, name: name, sessionLengths: entry.sessionLengths)
            }
        }.containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
        
}

#Preview {
    Large(entry: TimerEntry(race: RaceData(), tbc: false, flag: "", sessionLengths: DataConfig().sessionLengths))
}
