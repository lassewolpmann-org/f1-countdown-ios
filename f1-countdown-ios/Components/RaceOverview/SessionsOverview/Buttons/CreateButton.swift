//
//  CreateButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct CreateButton: View {
    @Binding var notificationEnabled: Bool;
    
    var sessionName: String;
    var sessionDate: String;
    var raceName: String;
    
    var body: some View {
        let notificationCenter = UNUserNotificationCenter.current();
        
        Button(role: .none) {
            notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print(error)
                } else if (granted) {
                    notificationCenter.getNotificationSettings { settings in
                        guard (settings.authorizationStatus == .authorized) ||
                                (settings.authorizationStatus == .provisional) else {
                            print("Notifications not allowed")
                            
                            return
                        }

                        if settings.alertSetting == .enabled {
                            let date = formatDate(dateString: sessionDate);
                            let calendarDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
                            
                            let trigger = UNCalendarNotificationTrigger(dateMatching: calendarDate, repeats: false);

                            let content = UNMutableNotificationContent();
                            content.title = "\(raceName) Grand Prix";
                            content.subtitle = "\(parseSessionName(sessionName: sessionName)) is now live!"
                            content.sound = UNNotificationSound.default;
                            
                            let request = UNNotificationRequest(identifier: sessionDate, content: content, trigger: trigger);
                            
                            notificationCenter.add(request) { (error) in
                                if error != nil {
                                    print("Error while creating notification")
                                } else {
                                    notificationEnabled = true;
                                }
                            }
                        } else {
                            // Schedule a notification with a badge and sound.
                        }
                    }
                }
            }
        } label: {
                Label("Create Alert", systemImage: "bell")
        }
        .buttonStyle(.bordered)
        .labelStyle(.iconOnly)
    }
}

#Preview {
    CreateButton(notificationEnabled: .constant(false), sessionName: "fp1", sessionDate: "1970-01-01T00:00:00Z", raceName: "undefined")
}
