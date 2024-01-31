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
        let granted: Bool = try await center.requestAuthorization(options: [.alert, .sound, .badge])
        print("Granted", granted)
    } catch {
        print("Error")
    }
}

func checkForPermission() async -> Bool {
    let center = UNUserNotificationCenter.current()
    do {
         if try await center.requestAuthorization() == true {
             print("App has permission")
            return true
         } else {
             print("App does not have permission")
            return false
         }
    } catch {
        print("Error")
        return false
    }
}

func checkForExistingNotification(sessionDate: Date) async -> Bool {
    let center = UNUserNotificationCenter.current();
    let requests = await center.pendingNotificationRequests();
    
    let requestsWithSameID = requests.filter { request in
        return request.identifier == sessionDate.description
    }
    
    if (requestsWithSameID.isEmpty) {
        return false;
    } else {
        return true;
    }
}
