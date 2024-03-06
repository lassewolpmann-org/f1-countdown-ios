//
//  CreateNotification.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 31.1.2024.
//

import Foundation
import UserNotifications

func createNotification(race: RaceData, series: String, sessionDate: String, sessionName: String) async -> Bool {
    let center = UNUserNotificationCenter.current();
    let date = ISO8601DateFormatter().date(from: sessionDate)!;
    let notificationTimeSetting = UserDefaults.standard.integer(forKey: "Notification");
    
    if (await checkForPermission()) {
        let calendarDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date.addingTimeInterval(TimeInterval(-notificationTimeSetting * 60)));
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendarDate, repeats: false);
        
        let content = UNMutableNotificationContent();
        let session = parseSessionName(sessionName: sessionName);
        let series = series.uppercased()
        
        content.title = "\(getRaceTitle(race: race))";
        content.body = notificationTimeSetting == 0 ? "\(series) \(session) is now live!" : "\(series) \(session) starts in \(notificationTimeSetting.description) minutes!";
        content.sound = UNNotificationSound.default;
        print(content.title, content.body, trigger)
                
        let notification = UNNotificationRequest(identifier: sessionDate, content: content, trigger: trigger);
        
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
