//
//  NotificationButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct NotificationButton: View {
    @State private var notificationEnabled: Bool = false
    @State private var buttonState: Bool = false
    
    let session: Season.Race.Session
    let sessionStatus: Season.Race.Session.Status
    let race: RaceData
    let notificationController: NotificationController
    
    var body: some View {
        Button {
            buttonState.toggle();
            
            if (notificationEnabled) {
                let dates = notificationController.selectedOffsetOptions.map { offset in
                    return session.startDate.addingTimeInterval(TimeInterval(offset * -60)).ISO8601Format()
                }
                
                notificationController.center.removePendingNotificationRequests(withIdentifiers: dates)
                notificationEnabled = false
            } else {
                Task {
                    let status = await notificationController.permissionStatus
                    if (status == .authorized) {
                        for offset in notificationController.selectedOffsetOptions {
                            let notificationDate = session.startDate.addingTimeInterval(TimeInterval(offset * -60))
                            guard notificationDate.timeIntervalSinceNow > 0 else { continue }
                            
                            notificationEnabled = await notificationController.addNotification(sessionDate: session.startDate, sessionName: session.longName, series: race.series.uppercased(), title: race.race.title, offset: offset)
                        }
                    } else if (status == .notDetermined) {
                        await notificationController.createNotificationPermission()
                    } else {
                        print("Not allowed")
                    }
                }
            }
        } label: {
            Image(systemName: notificationEnabled ? "bell.slash" : "bell")
                .foregroundStyle(notificationEnabled ? .red : .accentColor)
                .contentTransition(.symbolEffect(.replace))
        }
        .disabled(sessionStatus != .upcoming)
        .sensoryFeedback(.success, trigger: buttonState)
        .buttonStyle(.bordered)
        .task {
            notificationEnabled = await notificationController.getCurrentNotificationDates().contains(session.startDate)
        }
    }
}

#Preview {
    if let race = sampleRaces.first {
        if let session = race.race.sessions.first {
            NotificationButton(session: session, sessionStatus: .upcoming, race: race, notificationController: NotificationController())
        }
    }
}
