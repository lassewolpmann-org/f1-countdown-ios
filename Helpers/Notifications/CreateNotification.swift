//
//  CreateNotification.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 31.1.2024.
//

import Foundation
import UserNotifications

func createNotification(sessionDate: Date, sessionName: String) async -> Bool {
    let center = UNUserNotificationCenter.current();
    
    if (await checkForPermission()) {
        let notificationTimeSetting = UserDefaults.standard.integer(forKey: "Notification");
        
        let calendarDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: sessionDate.addingTimeInterval(TimeInterval(notificationTimeSetting * 60)));
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendarDate, repeats: false);
        
        let content = UNMutableNotificationContent();
        content.title = "\(sessionName) is now live!"
        content.sound = UNNotificationSound.default;
        
        let notification = UNNotificationRequest(identifier: ISO8601DateFormatter().string(from: sessionDate), content: content, trigger: trigger);
        
        do {
            try await center.add(notification);
            print("Notifcation created")
            
            return true
        } catch {
            print("Error while creating notification")
            return false
        }
    } else {
        return false
    }
}
