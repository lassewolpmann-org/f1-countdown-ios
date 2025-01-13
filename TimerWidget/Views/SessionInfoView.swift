//
//  SessionInfo.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import SwiftUI
import WidgetKit

struct SessionInfo: View {
    let session: Season.Race.Session
    
    var sessionStatus: Season.Race.Session.Status {
        let currentDate = Date()
        
        if (currentDate >= session.endDate) {
            return .finished
        } else if (currentDate >= session.startDate && currentDate < session.endDate) {
            return .ongoing
        } else {
            return .upcoming
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(session.longName)
                    .foregroundStyle(.red)
                
                Spacer()
                
                Text(session.dayString)
                    .foregroundStyle(.secondary)
            }
            
            let date = Date.now
            
            if (session.startDate.timeIntervalSinceNow >= 3600) {
                HStack {
                    Label {
                        Text(session.startDate, style: .date)
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    
                    Spacer()
                    
                    Text(DateInterval(start: session.startDate, end: session.endDate))
                }
            } else {
                Label {
                    switch sessionStatus {
                    case .finished:
                        Text("Finished")
                    case .ongoing:
                        Text("Session ends in \(timerInterval: date...session.endDate, pauseTime: date)")
                    case .upcoming:
                        Text("Session starts in \(timerInterval: date...session.startDate, pauseTime: date)")
                    }
                } icon: {
                    switch sessionStatus {
                    case .finished:
                        Image(systemName: "flag.checkered.2.crossed")
                    case .ongoing:
                        Image(systemName: "flag.checkered")
                    case .upcoming:
                        Image(systemName: "clock")
                    }
                }
            }
        }
        .font(.subheadline)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(.quinary)
        )
    }
}

#Preview(as: .systemLarge) {
    TimerWidget()
} timeline: {
    TimerEntry(date: Date(), race: sampleRaces.first?.race)
}
