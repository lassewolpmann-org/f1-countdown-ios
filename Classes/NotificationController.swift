//
//  NotificationController.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.7.2024.
//

import Foundation
import UserNotifications

class NotificationController {
    let center = UNUserNotificationCenter.current()
    
    // MARK: Computed properties
    var permissionStatus: UNAuthorizationStatus {
        get async {
            await center.notificationSettings().authorizationStatus
        }
    }
    
    var currentNotifications: [UNNotificationRequest] {
        get async {
            await center.pendingNotificationRequests()
        }
    }
    
    // MARK: Functions
    func createNotificationPermission() async -> Void {
        do {
            try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Error while granting Notification Permission")
        }
    }
    
    func addNotification(sessionDate: Date, sessionName: String, series: String, title: String, offset: Int) async -> Bool {
        guard await self.permissionStatus == .authorized else { return false }
        
        // FOR TESTING NOTIFICATIONS
        // let testDate = Date().addingTimeInterval(5)
        // let testDateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: testDate)
        
        let notificationDate = sessionDate.addingTimeInterval(TimeInterval(offset * -60))
        let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: notificationDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = offset == 0 ? "\(series) \(sessionName) is now live!" : "\(series) \(sessionName) starts in \(offset.description) minutes!"
        content.sound = .default
        content.interruptionLevel = .active
        content.userInfo = [
            "series": series,
            "sessionName": sessionName,
            "sessionDate": sessionDate
        ]
        
        let notification = UNNotificationRequest(identifier: notificationDate.ISO8601Format(), content: content, trigger: trigger)
        
        do {
            try await center.add(notification)
        } catch {
            print(error)
        }
        
        return true
    }
    
    func removeNotification(identifier: String) -> Void {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
