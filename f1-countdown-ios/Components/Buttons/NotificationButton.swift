//
//  NotificationButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct NotificationButton: View {
    let raceName: String;
    let sessionName: String;
    let sessionDate: Date;
    
    @State var notificationEnabled: Bool = false;
    
    var body: some View {
        VStack {
            if (sessionDate.timeIntervalSinceNow > 0) {
                if (notificationEnabled) {
                    DeleteButton(notificationEnabled: $notificationEnabled, sessionDate: sessionDate)
                } else {
                    CreateButton(notificationEnabled: $notificationEnabled, sessionName: sessionName, sessionDate: sessionDate, raceName: raceName)
                }
            } else {
                DisabledButton()
            }
        }.task {
            notificationEnabled = await checkForExistingNotification(sessionDate: sessionDate);
        }
    }
}

#Preview {
    NotificationButton(raceName: RaceData().name, sessionName: parseSessionName(sessionName: RaceData().sessions.first!.key), sessionDate: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!)
}
