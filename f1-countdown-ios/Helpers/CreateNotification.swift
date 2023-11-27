//
//  CreateNotification.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import Foundation
import UserNotifications

func createNotification(sessionDate: String, raceName: String, sessionName: String) -> Void {
    let notificationCenter = UNUserNotificationCenter.current();
    
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
                    let formatter = ISO8601DateFormatter();
                    let date = formatter.date(from: sessionDate)!;
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
                            print("Notifcation created")
                        }
                    }
                }
            }
        }
    }
}
