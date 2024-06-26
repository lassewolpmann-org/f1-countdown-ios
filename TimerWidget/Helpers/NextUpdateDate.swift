//
//  getNextSession.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import Foundation

func getNextUpdateDate(nextRace: RaceData?) -> Date {
    if let nextRace {
        let pastSessions = nextRace.pastSessions
        let ongoingSessions = nextRace.ongoingSessions
        let futureSessions = nextRace.futureSessions
        
        let allSessions = [pastSessions, ongoingSessions, futureSessions]
        
        var allDates: [Date] = []
        
        for sessions in allSessions {
            for session in sessions {
                allDates.append(session.value.startDate.addingTimeInterval(-60 * 60))   // Date one hour before session starts
                allDates.append(session.value.startDate)
                allDates.append(session.value.endDate)
            }
        }
        
        allDates = allDates.sorted { a, b in
            return a < b
        }
        
        let futureDates = allDates.filter { date in
            return date > Date()
        }
        
        guard let firstDate = futureDates.first else { return Date().addingTimeInterval(60 * 60) }

        return firstDate
    } else {
        return Date().addingTimeInterval(60 * 60)
    }
}
