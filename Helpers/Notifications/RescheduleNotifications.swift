//
//  RescheduleNotifications.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 26.2.2024.
//

import Foundation
import UserNotifications

func rescheduleNotifications(time: Int) async -> Void {
    // Save option ot User Defaults
    UserDefaults.standard.set(time, forKey: "Notification")
    
    // Update all Notifications
    let center = UNUserNotificationCenter.current();
    let notifications = await center.pendingNotificationRequests();
    
    for notification in notifications {
        // Step 1: Get Current Identifier which is the Date in ISO8601 format
        let identifier = notification.identifier;
        
        // Step 2: Get current content and extract series and session data from it
        let currentContent = notification.content;
        let series = currentContent.userInfo["series"] as? String ?? "undefined series";
        let session = currentContent.userInfo["session"] as? String ?? "undefined session";
        let title = currentContent.title;
        let body = time == 0 ? "\(series) \(session) is now live!" : "\(series) \(session) starts in \(time.description) minutes!";
        
        // Step 3: Create new Date with added Minutes
        let date = ISO8601DateFormatter().date(from: identifier)?.addingTimeInterval(TimeInterval(-time * 60)) ?? Date();
        let calendarDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date);
        
        // Step 4: Remove current Notification
        center.removePendingNotificationRequests(withIdentifiers: [identifier]);
        
        // Step 5: Create new Notification
        let success = await createNotification(identifier: identifier, date: calendarDate, title: title, body: body, series: series, session: session);
        
        if (!success) {
            print("Rescheduling of notification didn't work");
        }
    }
}
