//
//  Large.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import SwiftUI
import WidgetKit

struct Large: View {
    let race: Season.Race
    
    var body: some View {
        VStack(alignment: .leading) {
            WidgetHeader(race: race)
            
            ForEach(race.sessions, id: \.shortName) { session in
                SessionInfo(session: session)
            }
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
        
}

#Preview(as: .systemLarge) {
    TimerWidget()
} timeline: {
    TimerEntry(date: Date(), race: sampleRaces.first?.race)
}

