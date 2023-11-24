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
        let nextRace = nextRaces.first!;
        
        return nextRace
    } catch {
        print("Error calling API")
        
        return RaceData()
    }
}

func getSessionDate(race: RaceData) -> Date {
    let sortedSessions = race.sessions.sorted(by:{$0.value < $1.value});
    
    let firstSession = sortedSessions.first ?? RaceData().sessions.first!;
    let sessionDate = ISO8601DateFormatter().date(from: firstSession.value)!;
    
    return sessionDate
}

func getSessionName(race: RaceData) -> String {
    let sortedSessions = race.sessions.sorted(by:{$0.value < $1.value});
    
    let firstSession = sortedSessions.first ?? RaceData().sessions.first!;
    let sessionName = firstSession.key;
    
    return sessionName
}

func getDay(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "EEEE dd. MMM YYYY";
    
    return formatter.string(from: date)
}

func getTime(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "HH:mm"
    
    return formatter.string(from: date)
}

func getOnlyDay(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "dd. MMM YY";
    
    return formatter.string(from: date)
}

func getDayName(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "EEEE";
    
    return formatter.string(from: date)
}

func parseSessionName(name: String) -> String {
    if (name == "fp1") {
        return "Free Practice 1"
    } else if (name == "fp2") {
        return "Free Practice 2"
    } else if (name == "fp3") {
        return "Free Practice 3"
    } else if (name == "qualifying") {
        return "Qualifying"
    } else if (name == "sprintQualifying") {
        return "Sprint Qualifying"
    } else if (name == "gp") {
        return "Race"
    } else {
        return "undefined"
    }
}
