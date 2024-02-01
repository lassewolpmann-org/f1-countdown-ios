//
//  CreateButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct CreateButton: View {
    @Binding var notificationEnabled: Bool;
    @State private var showAlert = false;
    
    var sessionName: String;
    var sessionDate: Date;
    var raceName: String;
    
    var body: some View {
        Button {
            Task {
                notificationEnabled = await createNotification(sessionDate: sessionDate, raceName: raceName, sessionName: sessionName);
                
                if (!notificationEnabled) {
                    showAlert = true;
                }
            }
        } label: {
            Label("Create Alert", systemImage: "bell")
        }
        .buttonStyle(.bordered)
        .labelStyle(.iconOnly)
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
    }
}

#Preview {
    CreateButton(notificationEnabled: .constant(false), sessionName: parseSessionName(sessionName: RaceData().sessions.first!.key), sessionDate: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, raceName: RaceData().name)
}
