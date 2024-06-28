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
    var formattedName: String = "Session"
    var startDate: Date = Date().addingTimeInterval(60)
    var endDate: Date = Date().addingTimeInterval(120)
}

struct RaceData: Decodable, Identifiable, Hashable {
    var name: String = "Preview Grand Prix"
    var location: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var round: Int = 0
    var slug: String = ""
    var localeKey: String = ""
    var sessions: [String: String] = ["fp1": calcFutureDate(days: -1), "sprintQualifying": calcFutureDate(days: -0.0208333333), "sprint": calcFutureDate(days: 0.0001736111), "qualifying": calcFutureDate(days: 2), "gp": calcFutureDate(days: 3)]
    
    // Optionals
    var tbc: Bool? = false
    var series: String? = "f1"
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
                        
            return (key: sessionName, value: SessionData(formattedName: parseSessionName(sessionName: sessionName), startDate: startDate, endDate: endDate))
        }
        
        // Step 3: Sort session by ascending date
        return formattedSessions.sorted { a, b in
            a.value.startDate < b.value.startDate
        }
    }
    
    var pastSessions: [(key: String, value: SessionData)] {
        sortedSessions.filter { session in
            return session.value.endDate < Date()
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
