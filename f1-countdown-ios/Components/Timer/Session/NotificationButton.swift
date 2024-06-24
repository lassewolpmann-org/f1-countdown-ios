//
//  NotificationButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct NotificationButton: View {
    let session: SessionData
    let race: RaceData
    let series: String
    
    @State private var notificationEnabled: Bool = false;
    @State private var showAlert = false;
    @State private var allowButton: Bool = false;
    
    // Used to track sensory feedback
    @State private var buttonState: Bool = false;
    
    var body: some View {
        Button {
            buttonState.toggle();
            
            if (notificationEnabled) {
                notificationEnabled = deleteNotification(sessionDate: session.startDate)
            } else {
                Task {
                    notificationEnabled = await addNewNotification(race: race, series: series, sessionDate: session.startDate, sessionName: session.formattedName);
                    showAlert = !notificationEnabled;
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
        .sensoryFeedback(.error, trigger: showAlert)
        .buttonStyle(.bordered)
        .disabled(allowButton)
        .alert(
            Text("Notifications disabled"),
            isPresented: $showAlert
        ) {
            Button("OK") {
                showAlert.toggle()
            }
        } message: {
            Text("Please enable Notifications for Formula Countdown in your System Settings.")
        }
        .task {
            allowButton = notificationButtonDisabled(sessionDate: session.startDate);
            notificationEnabled = await checkForExistingNotification(sessionDate: session.startDate);
        }
    }
}

#Preview {
    NotificationButton(session: SessionData(), race: RaceData(), series: "f1")
}
