//
//  getNextSession.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import Foundation

func getNextUpdateDate(data: AppData) -> Date {
    let nextRace = data.nextRaces.first ?? RaceData();
    let firstSession = nextRace.futureSessions.first!;
    let sessionDate = ISO8601DateFormatter().date(from: firstSession.value)!;
    
    return sessionDate
}
