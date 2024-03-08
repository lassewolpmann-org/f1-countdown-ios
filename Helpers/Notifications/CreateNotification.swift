//
//  CreateNotification.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 31.1.2024.
//

import Foundation
import UserNotifications

func addNewNotification(race: RaceData, series: String, sessionDate: String, sessionName: String) async -> Bool {
    let identifier = sessionDate;
    
    let notificationTimeSetting = UserDefaults.standard.integer(forKey: "Notification");
    let date = ISO8601DateFormatter().date(from: sessionDate)?.addingTimeInterval(TimeInterval(-notificationTimeSetting * 60)) ?? Date();
    let calendarDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date);
    
    let session = parseSessionName(sessionName: sessionName);
    let series = series.uppercased();
    let title = "\(getRaceTitle(race: race))";
    let body = notificationTimeSetting == 0 ? "\(series) \(session) is now live!" : "\(series) \(session) starts in \(notificationTimeSetting.description) minutes!";
    
    return await createNotification(identifier: identifier, date: calendarDate, title: title, body: body, series: series, session: session)
}

func createNotification(identifier: String, date: DateComponents, title: String, body: String, series: String, session: String) async -> Bool {
    if (await checkForPermission()) {
        let center = UNUserNotificationCenter.current();
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false);
        
        let content = UNMutableNotificationContent();
        content.title = title;
        content.body = body;
        content.sound = UNNotificationSound.default;
        content.interruptionLevel = .timeSensitive;
        content.userInfo = [
            "series": series,
            "session": session
        ]
                
        let notification = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger);
                
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
