//
//  Notifications.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.5.2024.
//

import Foundation
import UserNotifications

func deleteNotification(sessionDate: Date) -> Bool {
    let notificationCenter = UNUserNotificationCenter.current();
    
    notificationCenter.removePendingNotificationRequests(withIdentifiers: [sessionDate.ISO8601Format()])
    
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
    let authStatus = await center.notificationSettings().authorizationStatus
    
    if (authStatus == .notDetermined) {
        await createNotificationPermission()
        return await checkForPermission()
    } else if (authStatus == .denied) {
        return false
    } else if (authStatus == .authorized) {
        return true
    } else {
        // Unknown case
        return false
    }
}

func addNewNotification(race: RaceData, series: String, sessionDate: Date, sessionName: String, userDefaults: UserDefaultsController) async -> Bool {
    let identifier = sessionDate.ISO8601Format();
    
    var success: [Bool] = []
    
    for offset in userDefaults.offsetValues {
        let date = sessionDate.addingTimeInterval(TimeInterval(-offset * 60));
        let calendarDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date);
        
        let series = series.uppercased();
        let title = "\(getRaceTitle(race: race))";
        let body = offset == 0 ? "\(series) \(sessionName) is now live!" : "\(series) \(sessionName) starts in \(offset.description) minutes!";
        
        success.append(await createNotification(identifier: identifier, date: calendarDate, title: title, body: body, series: series, session: sessionName))
    }
    
    print(success)
    
    if success.contains(false) {
        return false
    } else {
        return true
    }
}

func createNotification(identifier: String, date: DateComponents, title: String, body: String, series: String, session: String) async -> Bool {
    if (await checkForPermission()) {
        let center = UNUserNotificationCenter.current();
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false);
        
        let content = UNMutableNotificationContent();
        content.title = title;
        content.body = body;
        content.sound = .default;
        content.interruptionLevel = .timeSensitive;
        content.userInfo = [
            "series": series,
            "session": session
        ]
                
        let notification = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger);
        do {
            try await center.add(notification);
            
            return true
        } catch {
            print("Error while creating notification: \(error)")
            return false
        }
    } else {
        return false
    }
}

func rescheduleNotifications(time: Int) async -> Void {
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

func removeInvalidNotifications(appData: AppData) async {
    let center = UNUserNotificationCenter.current();
    let notifications = await center.pendingNotificationRequests();
    
    let sessionDates = appData.seriesData.flatMap { seriesData in
        return seriesData.value.flatMap { races in
            return races.sortedSessions.map { session in
                return session.value.startDate.ISO8601Format()
            }
        }
    }
        
    let invalidNotifications = notifications.filter {
        return !sessionDates.contains($0.identifier)
    }
        
    let identifiers = invalidNotifications.map { $0.identifier }
    print("Removing: \(identifiers)")
    center.removePendingNotificationRequests(withIdentifiers: identifiers)
}

func notificationButtonDisabled(sessionDate: Date, userDefaults: UserDefaultsController) -> Bool {
    if let firstOffset = userDefaults.offsetValues.first {
        return sessionDate.addingTimeInterval(TimeInterval(-firstOffset * 60)).timeIntervalSinceNow <= 0
    } else {
        return false
    }
}

func checkForExistingNotification(sessionDate: Date) async -> Bool {
    let center = UNUserNotificationCenter.current();
    let requests = await center.pendingNotificationRequests();
    let requestsWithSameID = requests.filter { request in
        return request.identifier == sessionDate.ISO8601Format()
    }
        
    if (requestsWithSameID.isEmpty) {
        return false;
    } else {
        return true;
    }
}
