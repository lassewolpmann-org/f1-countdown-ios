//
//  CreateNotificationPermission.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 31.1.2024.
//

import Foundation
import UserNotifications

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
