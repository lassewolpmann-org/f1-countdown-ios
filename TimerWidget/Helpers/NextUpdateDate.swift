//
//  getNextSession.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import Foundation

func getNextUpdateDate(nextRace: RaceData) -> Date {
    let firstSession = nextRace.futureSessions.first!;
    let sessionDate = ISO8601DateFormatter().date(from: firstSession.value)!;
    
    return sessionDate
    
    /*
    if (sessionDate.timeIntervalSinceNow > 60 * 60) {
        // Situation 1: More than one hour away from session -> Update next one hour before session start
        return sessionDate.addingTimeInterval(-1 * 60 * 60)
    } else {
        // Situation 2: Less than one hour away from session -> Update next at session start
        return sessionDate
    }
     */
}
