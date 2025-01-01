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
                Text(session.longName)
                    .foregroundStyle(.red)
                
                Spacer()
                
                Text(session.dayString)
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                let date = Date.now
                
                if (session.endDate <= date) {
                    Label("Finished", systemImage: "flag.checkered.2.crossed")
                } else if (session.endDate > date && session.startDate <= date) {
                    Label {
                        Text("Session ends in \(timerInterval: date...session.endDate, pauseTime: date)")
                    } icon: {
                        Image(systemName: "flag.checkered")
                    }
                } else if (session.startDate <= date.addingTimeInterval(60 * 60)) {
                    Label {
                        Text("Session starts in \(timerInterval: date...session.startDate, pauseTime: date)")
                    } icon: {
                        Image(systemName: "clock")
                    }
                } else {
                    Label {
                        Text(session.startDate, style: .date)
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    
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
    TimerEntry(date: Date.now)
}
