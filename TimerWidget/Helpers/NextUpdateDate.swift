//
//  getNextSession.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import Foundation

func getNextUpdateDate(race: RaceData) -> Date {
    let sessions = race.sessions.filter { session in
        let date = ISO8601DateFormatter().date(from: session.value)!
        
        return date.timeIntervalSinceNow > 0
    }
    
    let sortedSessions = sessions.sorted(by:{$0.value < $1.value});
    
    let firstSession = sortedSessions.first ?? RaceData().sessions.first!;
    let sessionDate = ISO8601DateFormatter().date(from: firstSession.value)!;
    
    return sessionDate
}
