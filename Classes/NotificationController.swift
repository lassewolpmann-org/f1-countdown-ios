//
//  NotificationController.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.7.2024.
//

import Foundation
import UserNotifications

struct ReturnMessage {
    var success: Bool?
    var message: String
}

@Observable class NotificationController {
    // Create variables for UserDefaults
    let key: String = "NotificationOffsets"
    let userDefaults = UserDefaults.standard
    var selectedOffsetOptions: [Int] = []
    var message: ReturnMessage = ReturnMessage(success: nil, message: "")
    
    // Create variables for Notification Center
    let center = UNUserNotificationCenter.current()
    
    init() {
        if (self.offsetValues.isEmpty) {
            self.selectedOffsetOptions = [0]
            userDefaults.set(self.selectedOffsetOptions, forKey: self.key)
        } else {
            selectedOffsetOptions = self.offsetValues
        }
    }
    
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
    
    var offsetValues: [Int] {
        let values = userDefaults.array(forKey: self.key)  as? [Int] ?? []
        
        return values.sorted { a, b in
            a < b
        }
    }
    
    // MARK: Functions
    func toggleOffsetValue(offset: Int) -> Void {
        var currentValues = self.offsetValues
                
        if (currentValues.contains(offset)) {
            guard currentValues.count > 1 else {
                message.success = false
                message.message = "Cannot remove only selected option"
                
                return
            }
            
            // Remove offset
            if let i = currentValues.firstIndex(of: offset) {
                currentValues.remove(at: i)
                message.success = true
                message.message = "Removed option"
            } else {
                message.success = false
                message.message = "Could not find option in list of selected options"
            }
        } else {
            // Append offset
            currentValues.append(offset)
            
            message.success = true
            message.message = "Added option"
        }
        
        self.selectedOffsetOptions = currentValues
        userDefaults.set(self.selectedOffsetOptions, forKey: self.key)
    }
    
    func getCurrentNotificationDates() async -> Set<Date> {
        let currentDates = await currentNotifications.compactMap { notification in
            if let sessionDate = notification.content.userInfo["sessionDate"] as? Date {
                return sessionDate
            } else {
                return nil
            }
        }
        
        return Set(currentDates)
    }
    
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
}
