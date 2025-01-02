//
//  Session.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI
import WidgetKit
import SwiftData

struct Session: View {
    @State var delta: DeltaValues

    let nextRace: RaceData
    let session: Season.Race.Session
    let currentDate: Date
    let notificationController: NotificationController
    
    var sessionStatus: Season.Race.Session.Status {
        if (currentDate >= session.endDate) {
            return .finished
        } else if (currentDate >= session.startDate && currentDate < session.endDate) {
            return .ongoing
        } else {
            return .upcoming
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text(session.longName)
                    .font(.headline)
                
                Spacer()
                
                Label {
                    Text(sessionStatus.rawValue)
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
                .font(.subheadline)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Label {
                        Text("\(session.dayString), \(session.dateString)")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    
                    Label {
                        Text(DateInterval(start: session.startDate, end: session.endDate))
                    } icon: {
                        Image(systemName: "clock")
                    }
                }
                
                Spacer()
                
                NotificationButton(session: session, sessionStatus: sessionStatus, race: nextRace, notificationController: notificationController)
            }
            .font(.body)
            
            HStack {
                if (sessionStatus == .upcoming) {
                    Text("Session starts in \(session.startDate, style: .relative)")
                } else if (sessionStatus == .ongoing) {
                    Text("Session ends in \(session.endDate, style: .relative)")
                } else {
                    Text("Session has ended.")
                }
                
                Spacer()
            }
            .font(.callout)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
        )
    }
}

#Preview(traits: .sampleData) {
    ScrollView {
        if let race = sampleRaces.first {
            if let session = race.race.sessions.first {
                let notificationController = NotificationController()
                let delta = DeltaValues(date: session.startDate)
                
                Session(delta: delta, nextRace: race, session: session, currentDate: Date(), notificationController: notificationController)
            }
        }
    }
}
