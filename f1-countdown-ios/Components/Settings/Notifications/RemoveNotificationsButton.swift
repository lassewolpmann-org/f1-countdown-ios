//
//  RemoveNotificationsButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 1.2.2024.
//

import SwiftUI

struct RemoveNotificationsButton: View {
    @State private var showAlert: Bool = false;
    @State private var buttonState: Bool = false;
    
    var body: some View {
        Button {
            buttonState.toggle();
            let center = UNUserNotificationCenter.current();
            center.removeAllPendingNotificationRequests();
            center.removeAllDeliveredNotifications();
            showAlert.toggle();
        } label: {
            Label("Remove all Notifications", systemImage: "bell.slash")
        }
        .alert(
            Text("Success"),
            isPresented: $showAlert
        ) {
            Button("OK") {
                showAlert.toggle()
            }
        } message: {
            Text("Removed all Notifications")
        }
        .sensoryFeedback(.success, trigger: buttonState)
    }
}

#Preview {
    RemoveNotificationsButton()
}
