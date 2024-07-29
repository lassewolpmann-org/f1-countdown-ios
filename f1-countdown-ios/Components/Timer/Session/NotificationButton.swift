//
//  NotificationButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct NotificationButton: View {
    var userDefaults: UserDefaultsController
    var notificationController: NotificationController

    let session: SessionData
    let race: RaceData
    let series: String
    
    @State private var notificationEnabled: Bool = false
    @State private var buttonDisabled: Bool = false
    
    // Used to track sensory feedback
    @State private var buttonState: Bool = false
    
    var body: some View {
        Button {
            buttonState.toggle();
            
            if (notificationEnabled) {
                for offset in userDefaults.selectedOffsetOptions {
                    let notificationDate = session.startDate.addingTimeInterval(TimeInterval(offset * -60))
                    notificationController.removeNotification(identifier: notificationDate.ISO8601Format())
                }
                
                notificationEnabled = false
            } else {
                Task {
                    let status = await notificationController.permissionStatus
                    if (status == .authorized) {
                        for offset in userDefaults.selectedOffsetOptions {
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
            // This needs to be done to avoid the Button Label changing size when Label Image changes.
            Image(systemName: "bell.slash")
                .hidden()
                .overlay {
                    Label(
                        notificationEnabled ? "Disable Notification" : "Enable Notification",
                        systemImage: notificationEnabled ? "bell.slash" : "bell"
                    )
                    .labelStyle(.iconOnly)
                    .symbolRenderingMode(notificationEnabled ? .multicolor : .monochrome)
                    .contentTransition(.symbolEffect(.replace))
                }
        }
        .sensoryFeedback(.success, trigger: buttonState)
        .buttonStyle(.bordered)
        .disabled(buttonDisabled)
        .task {
            buttonDisabled = session.startDate.timeIntervalSinceNow <= 0
            notificationEnabled = await isNotificationEnabled()
        }
    }
    
    func isNotificationEnabled() async -> Bool {
        let currentNotifications = await notificationController.currentNotifications.map { $0.identifier }
        for offset in userDefaults.selectedOffsetOptions {
            let notificationDate = session.startDate.addingTimeInterval(TimeInterval(offset * -60))
            if (currentNotifications.contains(notificationDate.ISO8601Format())) {
                return true
            }
        }
        
        return false
    }
}

#Preview {
    NotificationButton(userDefaults: UserDefaultsController(), notificationController: NotificationController(), session: SessionData(rawName: "undefined"), race: RaceData(), series: "f1")
}
