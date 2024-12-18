//
//  NotificationButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct NotificationButton: View {
    var notificationController: NotificationController

    let session: SessionData
    let race: RaceData
    let series: String
    
    @State private var notificationEnabled: Bool = false
    
    // Used to track sensory feedback
    @State private var buttonState: Bool = false
    
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
                            
                            notificationEnabled = await notificationController.addNotification(sessionDate: session.startDate, sessionName: session.longName, series: series.uppercased(), title: race.title, offset: offset)
                        }
                    } else if (status == .notDetermined) {
                        await notificationController.createNotificationPermission()
                    } else {
                        print("Not allowed")
                    }
                }
            }
        } label: {
            Label(
                notificationEnabled ? "Disable Notification" : "Enable Notification",
                systemImage: notificationEnabled ? "bell.slash" : "bell"
            )
            .labelStyle(.iconOnly)
            .symbolRenderingMode(notificationEnabled ? .multicolor : .monochrome)
            .contentTransition(.symbolEffect(.replace))
        }
        .sensoryFeedback(.success, trigger: buttonState)
        .buttonStyle(.bordered)
        .task {
            notificationEnabled = await notificationController.getCurrentNotificationDates().contains(session.startDate)
        }
        .onChange(of: session.status) { oldStatus, newStatus in
            print(newStatus)
            if (newStatus == .ongoing || newStatus == .finished) {
                notificationEnabled = false
            }
        }
    }
}

#Preview {
    NotificationButton(notificationController: NotificationController(), session: SessionData(rawName: "undefined", startDate: Date.now, endDate: Date.now), race: RaceData(), series: "f1")
}
