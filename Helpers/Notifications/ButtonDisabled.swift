//
//  ButtonDisabled.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 2.3.2024.
//

import Foundation

func notificationButtonDisabled(sessionDate: Date) -> Bool {
    let notificationTimeSetting = UserDefaults.standard.integer(forKey: "Notification");
    
    return sessionDate.addingTimeInterval(TimeInterval(-notificationTimeSetting * 60)).timeIntervalSinceNow <= 0
}
