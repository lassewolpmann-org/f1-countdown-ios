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
    @State var notificationsAllowed: Bool = false;
    
    var body: some View {
        let notificationCenter = UNUserNotificationCenter.current();
        
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
        }.onAppear {
            notificationCenter.getNotificationSettings { settings in
                if (settings.authorizationStatus == .authorized) {
                    notificationsAllowed = true
                    
                    notificationCenter.getPendingNotificationRequests { requestList in
                        let requestsWithSameID = requestList.filter { request in
                            return request.identifier == sessionDate.description
                        }
                        
                        if (requestsWithSameID.isEmpty) {
                            notificationEnabled = false;
                        } else {
                            notificationEnabled = true;
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationButton(raceName: RaceData().name, sessionName: parseSessionName(sessionName: RaceData().sessions.first!.key), sessionDate: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!)
}
