//
//  RemoveInvalidNotifications.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.2.2024.
//

import Foundation
import UserNotifications

func removeInvalidNotifications(races: [RaceData]) async {
    let center = UNUserNotificationCenter.current();
    let notifications = await center.pendingNotificationRequests();
    
    let sessionDates = races.flatMap {
        return $0.futureSessions.map {
            return $0.value
        }
    }
    
    let invalidNotifications = notifications.filter {
        return !sessionDates.contains($0.identifier)
    }.map {
        return $0.identifier
    }
    
    center.removePendingNotificationRequests(withIdentifiers: invalidNotifications)
}
