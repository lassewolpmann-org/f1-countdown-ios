//
//  NotificationButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct NotificationButton: View {
    var raceName: String;
    
    var sessionName: String;
    var sessionDate: String;
    
    @State var notificationEnabled: Bool = false;
    
    var body: some View {
        let notificationCenter = UNUserNotificationCenter.current();
        
        let formatter = ISO8601DateFormatter();
        let date = formatter.date(from: sessionDate);
        
        VStack {
            if (date!.timeIntervalSinceNow > 0) {
                if (notificationEnabled) {
                    DeleteButton(notificationEnabled: $notificationEnabled, sessionDate: sessionDate)
                } else {
                    CreateButton(notificationEnabled: $notificationEnabled, sessionName: sessionName, sessionDate: sessionDate, raceName: raceName)
                }
            } else {
                DisabledButton()
            }
        }.onAppear {
            notificationCenter.getPendingNotificationRequests { requestList in
                let requestsWithSameID = requestList.filter { request in
                    return request.identifier == sessionDate
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

#Preview {
    NotificationButton(raceName: "undefined", sessionName: "fp1", sessionDate: "1970-01-01T00:00:00Z")
}
