//
//  Notifications.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.5.2024.
//

import Foundation
import UserNotifications

func deleteNotification(sessionDate: String) -> Bool {
    let notificationCenter = UNUserNotificationCenter.current();
    
    notificationCenter.removePendingNotificationRequests(withIdentifiers: [sessionDate])
    
    return false
}

func createNotificationPermission() async -> Void {
    let center = UNUserNotificationCenter.current();
    
    do {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
    } catch {
        print("Error while granting Notification Permission")
    }
}

func checkForPermission() async -> Bool {
    let center = UNUserNotificationCenter.current()
    do {
         if try await center.requestAuthorization() == true {
            return true
         } else {
            return false
         }
    } catch {
        return false
    }
}

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

func removeInvalidNotifications(races: [RaceData]) async {
    let center = UNUserNotificationCenter.current();
    let notifications = await center.pendingNotificationRequests();
    
    let sessionDates = races.flatMap {
        return $0.futureSessions.map {
            return $0.value
        }
    }
    
    let invalidNotifications = notifications.filter {
        return !sessionDates.contains($0.identifier)
    }.map {
        return $0.identifier
    }
    
    center.removePendingNotificationRequests(withIdentifiers: invalidNotifications)
}

func notificationButtonDisabled(sessionDate: Date) -> Bool {
    let notificationTimeSetting = UserDefaults.standard.integer(forKey: "Notification");
    
    return sessionDate.addingTimeInterval(TimeInterval(-notificationTimeSetting * 60)).timeIntervalSinceNow <= 0
}

func checkForExistingNotification(sessionDate: String) async -> Bool {
    let center = UNUserNotificationCenter.current();
    let requests = await center.pendingNotificationRequests();
    
    let requestsWithSameID = requests.filter { request in
        return request.identifier == sessionDate
    }
    
    if (requestsWithSameID.isEmpty) {
        return false;
    } else {
        return true;
    }
}