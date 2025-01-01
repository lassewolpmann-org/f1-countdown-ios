//
//  Session.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI
import WidgetKit

struct Session: View {
    @State var delta: DeltaValues
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let nextRace: Season.Race
    let selectedSeries: String
    let notificationController: NotificationController
    @State var session: Season.Race.Session
    
    var body: some View {
        VStack {
            HStack {
                Text(session.longName)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Label {
                    Text(session.status.rawValue)
                } icon: {
                    switch session.status {
                    case .finished:
                        Image(systemName: "flag.checkered.2.crossed")
                    case .ongoing:
                        Image(systemName: "flag.checkered")
                    case .upcoming:
                        Image(systemName: "clock")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 5) {
                TimerElement(delta: delta.days, deltaPct: delta.daysPct, timeUnit: "days")
                Text(":")
                TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, timeUnit: "hours")
                Text(":")
                TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, timeUnit: "minutes")
                Text(":")
                TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, timeUnit: "seconds")
                
                NotificationButton(notificationController: notificationController, session: session, raceTitle: nextRace.title, series: selectedSeries)
                    .disabled(session.status != .upcoming)
                    .padding(.leading, 10)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
        )
        .onReceive(timer) { _ in
            let date = Date()
            
            if (date >= session.endDate) {
                session.status = .finished
            } else if (date > session.startDate && date < session.endDate) {
                session.status = .ongoing
            } else {
                session.status = .upcoming
            }
            
            delta = getDelta(session: session)
        }
        .onChange(of: session.status) { _, _ in
            // Reload widgets when Session Status changes
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview(traits: .sampleData) {
    ScrollView {
        let nextRace = sampleRaceData
        let selectedSeries = "f1"
        let notificationController = NotificationController()
        let session = sampleSessionData
        let delta = DeltaValues(date: session.startDate)
        
        Session(delta: delta, nextRace: nextRace, selectedSeries: selectedSeries, notificationController: notificationController, session: session)
    }
}
