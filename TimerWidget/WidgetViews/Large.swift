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
        VStack {
            VStack(alignment: .leading) {
                Text("\(entry.flag) \(entry.raceName) Grand Prix".uppercased())
                    .fontWeight(.semibold)
                    .font(.title3)
                
                
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(entry.sessions.sorted(by:{$0.value < $1.value}), id: \.key) { session in
                let name = session.key;
                let date = ISO8601DateFormatter().date(from: session.value)!
                
                Divider()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(getDayName(date: date))
                            .foregroundStyle(.red)
                        
                        Spacer()
                        
                        Text(parseSessionName(name: name))
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text(getOnlyDay(date: date))
                            .font(.title2)
                        Spacer()
                        Text("from \(getTime(date: date))")
                            .font(.title2)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .containerBackground(for: .widget) {
            
        }
    }
}

#Preview {
    Large(entry: TimerEntry(date: Date(), raceName: RaceData().name, sessions: RaceData().sessions, sessionDate: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, sessionName: "fp1", flag: ""))
}
