//
//  RescheduleNotifications.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 26.2.2024.
//

import Foundation
import UserNotifications

func rescheduleNotifications(time: Int) async {
    // Save option ot User Defaults
    UserDefaults.standard.set(time, forKey: "Notification")
    
    // Update all Notifications
    let center = UNUserNotificationCenter.current();
    let notifications = await center.pendingNotificationRequests();
    
    for notification in notifications {
        // Step 1: Get Current Identifier which is the Date in ISO8601 format
        let notificationIdentifier = notification.identifier;
        let notificationTitle = notification.content.title;
        let sessionName = notificationTitle.components(separatedBy: " ").first ?? "N/A";
        
        // Step 2: Remove current Notification
        center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier]);

        // Step 3: Create new Content for Notification
        let content = UNMutableNotificationContent();
        content.title = time == 0 ? "\(sessionName) is now live!" : "\(sessionName) starts in \(time.description) minutes!";
        content.sound = UNNotificationSound.default;
        
        // Step 4: Create new Date with added Minutes
        let notificationDate = ISO8601DateFormatter().date(from: notificationIdentifier);
        let newNotificationDate = notificationDate!.addingTimeInterval(TimeInterval(-time * 60));
        
        print(notification.trigger);
        let calendarDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: newNotificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendarDate, repeats: false);
        print(trigger);
        
        // Step 5: Create new Notification
        let newNotification = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger);
        
        do {
            try await center.add(newNotification);
            print("Notifcation created")
        } catch {
            print("Error while creating notification")
        }
    }
}
