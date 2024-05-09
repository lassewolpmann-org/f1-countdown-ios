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
    let race: RaceData;
    let series: String;
    
    @State private var notificationEnabled: Bool = false;
    @State private var showAlert = false;
    @State private var allowButton: Bool = false;
    
    // Used to track sensory feedback
    @State private var buttonState: Bool = false;
    
    var body: some View {
        let date = ISO8601DateFormatter().date(from: sessionDate)!;
        
        Button {
            buttonState.toggle();
            
            if (notificationEnabled) {
                notificationEnabled = deleteNotification(sessionDate: sessionDate)
            } else {
                Task {
                    notificationEnabled = await addNewNotification(race: race, series: series, sessionDate: sessionDate, sessionName: sessionName);
                    showAlert = !notificationEnabled;
                }
            }
        } label: {
            Label(
                notificationEnabled ? "Disable Notification" : "Enable Notification",
                systemImage: notificationEnabled ? "bell.slash" : "bell"
            )
            .labelStyle(.iconOnly)
            .padding(5)
            .symbolRenderingMode(notificationEnabled ? .multicolor : .monochrome)
            .contentTransition(.symbolEffect(.replace))
        }
        .overlay {
            Circle()
                .stroke(.tertiary)
        }
        .buttonBorderShape(.circle)
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
            allowButton = notificationButtonDisabled(sessionDate: date);
            notificationEnabled = await checkForExistingNotification(sessionDate: sessionDate);
        }
    }
}

#Preview {
    NotificationButton(sessionName: parseSessionName(sessionName: RaceData().futureSessions.first!.key), sessionDate: RaceData().futureSessions.first!.value, race: RaceData(), series: "f1")
}
