//
//  NotificationButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct NotificationButton: View {
    let sessionName: String;
    let sessionDate: String;
    
    @State var notificationEnabled: Bool = false;
    @State private var showAlert = false;
    
    var body: some View {
        let date = ISO8601DateFormatter().date(from: sessionDate)!;
        
        Button {
            if (notificationEnabled) {
                notificationEnabled = deleteNotification(sessionDate: sessionDate)
            } else {
                Task {
                    notificationEnabled = await createNotification(sessionDate: sessionDate, sessionName: sessionName);
                    showAlert = !notificationEnabled;
                }
            }
        } label: {
            Label(
                notificationEnabled ? "Disable Notification" : "Enable Notification",
                systemImage: notificationEnabled ? "bell.slash" : "bell"
            )
            .symbolRenderingMode(notificationEnabled ? .multicolor : .monochrome)
            .contentTransition(.symbolEffect(.replace))
        }
        .buttonStyle(.bordered)
        .labelStyle(.iconOnly)
        .disabled(date.timeIntervalSinceNow <= 0)
        .alert(
            Text("Notifications disabled"),
            isPresented: $showAlert
        ) {
            Button("OK") {
                showAlert.toggle()
            }
        } message: {
            Text("Please enable Notifications for the App in the System Settings")
        }
        .task {
            notificationEnabled = await checkForExistingNotification(sessionDate: sessionDate);
        }
    }
}

#Preview {
    NotificationButton(sessionName: parseSessionName(sessionName: RaceData().futureSessions.first!.key), sessionDate: RaceData().futureSessions.first!.value)
}
