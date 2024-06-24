//
//  SessionInfo.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import SwiftUI
import WidgetKit

struct SessionInfo: View {
    let session: SessionData
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(session.formattedName)
                    .foregroundStyle(.red)
                
                Spacer()
                
                Text(getDayName(date: session.startDate))
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                if (session.startDate.timeIntervalSinceNow <= 0) {
                    Label("Finished", systemImage: "flag.checkered")
                } else if (session.startDate.timeIntervalSinceNow <= 60 * 60) {
                    Text("Session starts in \(timerInterval: Date.now...session.startDate, pauseTime: Date.now)")
                } else {
                    Text(session.startDate, style: .date)
                    
                    Spacer()
                    
                    Text(DateInterval(start: session.startDate, end: session.endDate))
                }
            }
        }
        .font(.subheadline)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview(as: .systemLarge) {
    TimerWidget()
} timeline: {
    TimerEntry(sessions: [], name: "", tbc: false, flag: "")
}
