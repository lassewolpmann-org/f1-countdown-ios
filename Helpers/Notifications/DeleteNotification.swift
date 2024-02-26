//
//  DeleteNotification.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import Foundation
import UserNotifications

func deleteNotification(sessionDate: String) -> Bool {
    let notificationCenter = UNUserNotificationCenter.current();
    
    notificationCenter.removePendingNotificationRequests(withIdentifiers: [sessionDate])
    
    return false
}
