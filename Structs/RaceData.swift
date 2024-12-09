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

func calcFutureSeconds(seconds: Double) -> String {
    let futureDate = Date().addingTimeInterval(seconds);
    
    return ISO8601DateFormatter().string(from: futureDate)
}

enum SessionStatus: String {
    case finished = "Finished"
    case ongoing = "Ongoing"
    case upcoming = "Upcoming"
}

struct SessionData {
    let dateFormatter = DateFormatter()
    let rawName: String
    
    var startDate: Date
    var endDate: Date
    var status: SessionStatus {
        let date = Date.now
        
        if (date >= endDate) {
            return .finished
        } else if (date >= startDate && date < endDate) {
            return .ongoing
        } else {
            return .upcoming
        }
    }
    
    var dateString: String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: startDate)
    }
    
    var timeString: String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: startDate)
    }
    
    var dayString: String {
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: startDate)
    }
    
    var shortName: String {
        switch (self.rawName) {
        case "fp1":
            return "FP1"
        case "fp2":
            return "FP2"
        case "fp3":
            return "FP3"
        case "practice":
            return "P"
        case "qualifying":
            return "Q"
        case "qualifying1":
            return "Q1"
        case "qualifying2":
            return "Q2"
        case "sprintQualifying":
            return "SQ"
        case "sprint":
            return "Sprint"
        case "gp":
            return "Race"
        case "feature":
            return "Feature"
        case "race1":
            return "Race 1"
        case "race2":
            return "Race 2"
        case "race3":
            return "Race 3"
        default:
            return "?"
        }
    }
    
    var longName: String {
        switch (self.rawName) {
        case "fp1":
            return "Free Practice 1"
        case "fp2":
            return "Free Practice 2"
        case "fp3":
            return "Free Practice 3"
        case "practice":
            return "Practice"
        case "qualifying":
            return "Qualifying"
        case "qualifying1":
            return "1st Qualifying"
        case "qualifying2":
            return "2nd Qualifying"
        case "sprintQualifying":
            return "Sprint Qualifying"
        case "sprint":
            return "Sprint"
        case "gp":
            return "Race"
        case "feature":
            return "Feature"
        case "race1":
            return "1st Race"
        case "race2":
            return "2nd Race"
        case "race3":
            return "3rd Race"
        default:
            return "Undefined Session"
        }
    }
}

struct RaceData: Decodable, Identifiable, Hashable {
    var name: String = "Preview Grand Prix"
    var location: String = "Location"
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var round: Int = 0
    var slug: String = ""
    var localeKey: String = ""
    var sessions: [String: String] = ["fp1": calcFutureSeconds(seconds: -55), "sprintQualifying": calcFutureSeconds(seconds: -50), "sprint": calcFutureSeconds(seconds: -45), "qualifying": calcFutureSeconds(seconds: -40), "gp": calcFutureSeconds(seconds: 5)]
    
    // Optionals
    var tbc: Bool? = false
    var sessionLengths: [String: Int]?
    
    var formattedSessions: [SessionData] {
        // Step 1: Fix session date values
        var fixedSessions: [String: String] = [:]
        for session in sessions {
            if (session.value.contains(".000")) {
                let fixedDate = session.value.components(separatedBy: ".000");
                fixedSessions[session.key] = fixedDate.first! + fixedDate.last!
            } else {
                fixedSessions[session.key] = session.value
            }
        }
        
        // Step 2: Add extra data
        var formattedSessions: [SessionData] = []
        
        for session in fixedSessions {
            let sessionName = session.key
            let startDateString = session.value
            guard let sessionLength = sessionLengths?[sessionName] else { continue }
            
            let formatter = ISO8601DateFormatter()
            
            guard let startDate = formatter.date(from: startDateString) else { continue }
            let endDate = startDate.addingTimeInterval(Double(sessionLength) * 60)
            
            formattedSessions.append(SessionData(rawName: sessionName, startDate: startDate, endDate: endDate))
        }
        
        return formattedSessions
    }
    
    var sortedSessions: [SessionData] {
        formattedSessions.sorted { a, b in
            a.startDate < b.startDate
        }
    }
    
    var pastSessions: [SessionData] {
        sortedSessions.filter { session in
            return session.endDate < Date()
        }
    }
    
    var ongoingSessions: [SessionData] {
        sortedSessions.filter { session in
            return session.startDate < Date() && session.endDate >= Date()
        }
    }

    var futureSessions: [SessionData] {
        sortedSessions.filter { session in
            return session.startDate >= Date()
        }
    }
    
    var flag: String {
        return CountryFlags().flags[self.localeKey] ?? "🏳️"
    }
    
    var id: String {
        name
    }
    
    var title: String {
        let name = self.name;
        let flag = self.flag;
        
        if (name.contains("Grand Prix")) {
            return "\(flag) \(name)"
        } else {
            return "\(flag) \(name) Grand Prix"
        }
    }
}
