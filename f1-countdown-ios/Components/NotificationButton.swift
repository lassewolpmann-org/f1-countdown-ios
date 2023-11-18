//
//  NotificationButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct NotificationButton: View {
    var sessionDate: String;
    
    @State var notificationEnabled: Bool = false;
    @State var notificationUUID: String?;
    
    var body: some View {
        let sessionTimestamp = formatDate(dateString: sessionDate).timeIntervalSince1970;
        let currentTimestamp = Date().timeIntervalSince1970;
        
        if (sessionTimestamp > currentTimestamp) {
            if (notificationEnabled) {
                Button(role: ButtonRole.destructive) {
                    notificationEnabled = false;
                    
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationUUID!])
                    
                    
                } label: {
                    Label("Delete Alert", systemImage: "bell.slash")
                }
                .buttonStyle(.bordered)
                .labelStyle(.iconOnly)
            } else {
                Button(role: .none) {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if let error = error {
                            print(error)
                        }
                    }
                    
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        guard (settings.authorizationStatus == .authorized) ||
                                (settings.authorizationStatus == .provisional) else {
                            print("Notifications not allowed")
                            
                            return
                        }

                        if settings.alertSetting == .enabled {
                            notificationEnabled = true;
                            notificationUUID = sessionDate;
                            
                            let date = formatDate(dateString: sessionDate);
                            let calendarDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
                            
                            let trigger = UNCalendarNotificationTrigger(dateMatching: calendarDate, repeats: false);

                            let content = UNMutableNotificationContent();
                            content.title = "Session is now live!";
                            content.sound = UNNotificationSound.default;
                            
                            let request = UNNotificationRequest(identifier: sessionDate, content: content, trigger: trigger);
                            
                            UNUserNotificationCenter.current().add(request) { (error) in
                                if error != nil {
                                    print("Error while creating notification")
                                } else {
                                    print("Created notification")
                                }
                            }
                        } else {
                            // Schedule a notification with a badge and sound.
                        }
                    }
                } label: {
                        Label("Create Alert", systemImage: "bell")
                }
                .buttonStyle(.bordered)
                .labelStyle(.iconOnly)
            }
        } else {
            Button {
                print("Do nothing, button is disabled")
            } label: {
                Label("Create Alert", systemImage: "bell")
            }
            .buttonStyle(.bordered)
            .labelStyle(.iconOnly)
            .disabled(true)
        }
    }
}

#Preview {
    NotificationButton(sessionDate: "1970-01-01T00:00:00Z")
}
