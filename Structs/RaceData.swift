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

struct RaceData: Decodable, Identifiable, Hashable {
    var name: String = "Undefined"
    var location: String = "undefined place"
    var latitude: Double = 53.5
    var longitude: Double = 9.5
    var round: Int = 0
    var slug: String = "undefined-grand-prix"
    var localeKey: String = "undefined-grand-prix"
    var tbc: Bool?
    var sessions: [String: String] = ["fp1": ISO8601DateFormatter().string(from: Date().addingTimeInterval(30)), "sprintQualifying": calcFutureDate(days: 7), "sprint": calcFutureDate(days: 8), "qualifying": calcFutureDate(days: 9), "gp": calcFutureDate(days: 10)]
    
    var sessionLengths: [String: Double] {
        return SessionLengths().lengths
    }
    
    var fixedSessions: [(key: String, value: String)] {
        sessions.map {
            if ($0.value.contains(".000")) {
                let fixedDate = $0.value.components(separatedBy: ".000");
                
                return (key: $0.key, value: fixedDate.first! + fixedDate.last!)
            } else {
                return (key: $0.key, value: $0.value)
            }
        }
    }
    
    var sortedSessions: [(key: String, value: String)] {
        return fixedSessions.sorted(by:{$0.value < $1.value})
    }
    
    var futureSessions: [(key: String, value: String)] {
        sortedSessions.filter { (key: String, value: String) in
            let date = ISO8601DateFormatter().date(from: value)!;
            
            return date.timeIntervalSinceNow > 0
        }
    }
    
    var flag: String {
        return CountryFlags().flags[self.localeKey] ?? "🏳️"
    }
    
    var id: String {
        name
    }
}
