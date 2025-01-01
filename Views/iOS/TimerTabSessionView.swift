//
//  Session.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct Session: View {
    @State var delta: DeltaValues
    @State var sessionStatus: SessionStatus
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let nextRace: RaceData
    let selectedSeries: String
    let notificationController: NotificationController
    let session: SessionData
    
    var body: some View {
        VStack {
            HStack {
                Text(session.longName)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
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
                
                NotificationButton(notificationController: notificationController, session: session, sessionStatus: sessionStatus, raceTitle: nextRace.title, series: "f1")
                    .disabled(sessionStatus != .upcoming)
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
                sessionStatus = .finished
            } else if (date > session.startDate && date < session.endDate) {
                sessionStatus = .ongoing
            } else {
                sessionStatus = .upcoming
            }
            
            delta = getDelta(session: session)
        }
    }
}

#Preview(traits: .sampleData) {
    ScrollView {
        let nextRace = sampleRaceData
        let selectedSeries = "f1"
        let notificationController = NotificationController()
        let session = sampleSessionData
        let sessionStatus = getSessionStatus(session: session)
        let delta = DeltaValues(date: session.startDate)
        
        Session(delta: delta, sessionStatus: sessionStatus, nextRace: nextRace, selectedSeries: selectedSeries, notificationController: notificationController, session: session)
    }
}
