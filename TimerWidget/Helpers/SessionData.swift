//
//  getNextSession.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 24.11.2023.
//

import Foundation

func getNextRace() async -> RaceData {
    do {
        let date = Date();
        let calendar = Calendar.current;
        let year = calendar.component(.year, from:date);
        
        let nextRaces = try await callAPI(year: year);
        
        if (nextRaces.isEmpty) {
            let nextYearRaces = try await callAPI(year: year + 1);
            
            return nextYearRaces.first!
        } else {
            return nextRaces.first!
        }
    } catch {
        print("Error calling API")
        
        return RaceData()
    }
}

func getSessionDate(race: RaceData) -> Date {
    let sessions = race.sessions.filter { session in
        let date = ISO8601DateFormatter().date(from: session.value)!
        
        return date.timeIntervalSinceNow > 0
    }
    
    let sortedSessions = sessions.sorted(by:{$0.value < $1.value});
    
    let firstSession = sortedSessions.first ?? RaceData().sessions.first!;
    let sessionDate = ISO8601DateFormatter().date(from: firstSession.value)!;
    
    return sessionDate
}

func getSessionName(race: RaceData) -> String {
    let sessions = race.sessions.filter { session in
        let date = ISO8601DateFormatter().date(from: session.value)!
        
        return date.timeIntervalSinceNow > 0
    }
    
    let sortedSessions = sessions.sorted(by:{$0.value < $1.value});
    
    let firstSession = sortedSessions.first ?? RaceData().sessions.first!;
    let sessionName = firstSession.key;
    
    return sessionName
}
