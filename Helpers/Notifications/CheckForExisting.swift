//
//  CheckForExisting.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 8.3.2024.
//

import Foundation
import UserNotifications

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
