//
//  DeleteNotification.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import Foundation
import UserNotifications

func deleteNotification(sessionDate: String) -> Void {
    let notificationCenter = UNUserNotificationCenter.current();
    
    notificationCenter.removePendingNotificationRequests(withIdentifiers: [sessionDate])
}
