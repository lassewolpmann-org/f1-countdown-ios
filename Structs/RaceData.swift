//
//  RaceData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 7.2.2024.
//

import Foundation

func calcFutureDate(days: Double) -> String {
    let seconds = days * 24 * 60 * 60;
    let futureDate = Date().addingTimeInterval(seconds);
    
    return ISO8601DateFormatter().string(from: futureDate)
}

struct SessionData {
    var formattedName: String = ""
    var startDate: Date = Date()
    var endDate: Date = Date()
    var delta: DeltaValues = DeltaValues(date: Date())
}

struct RaceData: Decodable, Identifiable, Hashable {
    var name: String = ""
    var location: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var round: Int = 0
    var slug: String = ""
    var localeKey: String = ""
    var sessions: [String: String] = ["fp1": calcFutureDate(days: 0.0006944444444 / 4), "sprintQualifying": calcFutureDate(days: 10), "sprint": calcFutureDate(days: 11), "qualifying": calcFutureDate(days: 12), "gp": calcFutureDate(days: 13)]
    
    // Optionals
    var tbc: Bool?
    var series: String?
    var sessionLengths: [String: Double]? {
        if let series {
            return SessionLengths().series[series]
        } else {
            return nil
        }
    }
    
    var sortedSessions: [(key: String, value: SessionData)] {
        // Step 1: Fix session date values
        let fixedSessions = sessions.map { session in
            if (session.value.contains(".000")) {
                let fixedDate = session.value.components(separatedBy: ".000");
                
                return (key: session.key, value: fixedDate.first! + fixedDate.last!)
            } else {
                return (key: session.key, value: session.value)
            }
        }
        
        // Step 2: Add extra data
        let formattedSessions: [(key: String, value: SessionData)] = fixedSessions.map { session in
            let sessionName = session.key
            let startDateString = session.value
            guard let sessionLength = sessionLengths?[sessionName] else { return (key: sessionName, value: SessionData()) }
            
            let formatter = ISO8601DateFormatter()
            
            guard let startDate = formatter.date(from: startDateString) else { return (key: sessionName, value: SessionData()) }
            let endDate = startDate.addingTimeInterval(sessionLength * 60)
            
            let delta = DeltaValues(date: startDate)
            
            return (key: sessionName, value: SessionData(formattedName: parseSessionName(sessionName: sessionName), startDate: startDate, endDate: endDate, delta: delta))
        }
        
        // Step 3: Sort session by ascending date
        return formattedSessions.sorted { a, b in
            a.value.startDate < b.value.startDate
        }
    }
    
    var ongoingSessions: [(key: String, value: SessionData)] {
        sortedSessions.filter { session in
            let startDate = session.value.startDate
            let endDate = session.value.endDate
            
            return startDate < Date() && endDate > Date()
        }
    }

    var futureSessions: [(key: String, value: SessionData)] {
        sortedSessions.filter { session in
            return session.value.startDate > Date()
        }
    }
    
    var flag: String {
        return CountryFlags().flags[self.localeKey] ?? "🏳️"
    }
    
    var id: String {
        name
    }
}
