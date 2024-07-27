//
//  NotificationController.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.7.2024.
//

import Foundation
import UserNotifications

class NotificationController {
    struct NotificationObject {
        let identifier: String
        let date: DateComponents
        let series: String
        let title: String
        let body: String
    }
    
    let center = UNUserNotificationCenter.current()
    var notificationsAllowed: UNAuthorizationStatus = .denied
    
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
    
    func createNotificationObject() -> NotificationObject? {
        return nil
    }
    
    func addNotification() async -> Void {
        
    }
    
    func rescheduleNotification() async -> Void {
        
    }
    
    func removeNotification(identifier: String) -> Void {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
