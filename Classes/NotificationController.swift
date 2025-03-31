//
//  NotificationController.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.7.2024.
//

import Foundation
import UserNotifications

@Observable class NotificationController {
    struct ReturnMessage: Equatable, Identifiable {
        var id: UUID = UUID()
        var success: Bool
        var message: String
    }
    
    // Create variables for UserDefaults
    let key: String = "NotificationOffsets"
    let userDefaults = UserDefaults.standard
    let notificationOffsetOptions = [0, 5, 10, 15, 30, 60]
    
    var selectedOffsetOptions: [Int] = []
    var returnMessage: NotificationController.ReturnMessage = .init(success: false, message: "")
    
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
    func toggleOffsetValue(offset: Int) {
        var currentValues = self.offsetValues
        
        if (currentValues.contains(offset)) {
            guard currentValues.count > 1 else {
                self.returnMessage = .init(success: false, message: "Cannot remove only selected option")
                
                return
            }
            guard let index = currentValues.firstIndex(of: offset) else {
                self.returnMessage = .init(success: false, message: "Could not find option in list of selected options")
                
                return
            }
            
            currentValues.remove(at: index)
            self.selectedOffsetOptions = currentValues
            userDefaults.set(self.selectedOffsetOptions, forKey: self.key)
            self.returnMessage = .init(success: true, message: "Removed Option")
            
            return
        } else {
            // Append offset
            currentValues.append(offset)
            self.selectedOffsetOptions = currentValues
            userDefaults.set(self.selectedOffsetOptions, forKey: self.key)
            self.returnMessage = .init(success: true, message: "Added Option")
            
            return
        }
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
    
    func addSessionNotifications(race: RaceData, session: Season.Race.Session) async -> Void {
        if await self.permissionStatus == .notDetermined { await createNotificationPermission() }
        guard await self.permissionStatus == .authorized else {
            self.returnMessage = .init(success: false, message: "App does not have permission to send Notifications")
            return
        }
        
        for offset in self.selectedOffsetOptions {
            let notificationDate = session.startDate.addingTimeInterval(TimeInterval(offset * -60))
            guard notificationDate.timeIntervalSinceNow > 0 else { continue }

            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: notificationDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let content = UNMutableNotificationContent()
            
            content.title = race.race.title
            content.body = offset == 0 ? "\(race.series.uppercased()) \(session.longName) is now live!" : "\(race.series.uppercased()) \(session.longName) starts in \(offset.description) minutes!"
            content.sound = .default
            content.interruptionLevel = .active
            content.userInfo = [
                "series": race.series,
                "sessionName": session.longName,
                "sessionDate": session.startDate,
                "raceSlug": race.race.slug
            ]
            
            let notification = UNNotificationRequest(identifier: notificationDate.ISO8601Format(), content: content, trigger: trigger)
            
            do {
                try await center.add(notification)
            } catch {
                self.returnMessage = .init(success: false, message: error.localizedDescription)
                
                return
            }
        }
        
        self.returnMessage = .init(success: true, message: "Notification\(self.selectedOffsetOptions.count > 1 ? "s" : "") added for \(session.longName)")
        
        return
    }
}
