//
//  RaceData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 7.2.2024.
//

import Foundation

struct RaceData: Decodable, Identifiable, Hashable {
    var name: String = "undefined"
    var location: String = "undefined place"
    var latitude: Double = 53.5
    var longitude: Double = 9.5
    var round: Int = 0
    var slug: String = "undefined-grand-prix"
    var localeKey: String = "undefined-grand-prix"
    var tbc: Bool?
    var sessions: [String: String] = ["fp1": "2024-02-06T00:00:00Z", "sprintQualifying": "2024-02-07T01:00:00Z", "sprint": "2024-02-08T00:00:00Z", "qualifying": "2024-02-09T00:00:00Z", "gp": "2024-02-10T00:00:00Z"]
    
    var sortedSessions: [(key: String, value: String)] {
        sessions.sorted(by:{$0.value < $1.value})
    }
    
    var futureSessions: [(key: String, value: String)] {
        sortedSessions.filter { (key: String, value: String) in
            let date = ISO8601DateFormatter().date(from: value)!;
            
            return date.timeIntervalSinceNow > 0
        }
    }
    
    var id: String {
        name
    }
}
