//
//  Large.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import SwiftUI
import WidgetKit

struct Large: View {
    let entry: TimerEntry;
    
    var body: some View {
        VStack(alignment: .leading) {
            WidgetHeader(entry: entry)
            
            ForEach(entry.sessions, id: \.startDate) { session in
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
    TimerEntry(sessions: [], name: "", tbc: true, flag: "")
}

