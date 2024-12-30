//
//  AppData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.2.2024.
//

import Foundation
import SwiftData
import CoreLocation

let availableSeries: [String] = ["f1", "f2", "f3", "f1-academy"]
let flags = [
    "bahrain-grand-prix": "🇧🇭",
    "bahrain": "🇧🇭",
    "saudi-arabia-grand-prix": "🇸🇦",
    "saudi-arabia": "🇸🇦",
    "australian-grand-prix": "🇦🇺",
    "melbourne": "🇦🇺",
    "japanese-grand-prix": "🇯🇵",
    "chinese-grand-prix": "🇨🇳",
    "miami-grand-prix": "🇺🇸",
    "emilia-romagna-grand-prix": "🇮🇹",
    "emilia-romagna": "🇮🇹",
    "monaco-grand-prix": "🇲🇨",
    "monaco": "🇲🇨",
    "canadian-grand-prix": "🇨🇦",
    "spanish-grand-prix": "🇪🇸",
    "spanish": "🇪🇸",
    "austrian-grand-prix": "🇦🇹",
    "austrian": "🇦🇹",
    "british-grand-prix": "🇬🇧",
    "british": "🇬🇧",
    "hungarian-grand-prix": "🇭🇺",
    "hungarian": "🇭🇺",
    "belgian-grand-prix": "🇧🇪",
    "belgian": "🇧🇪",
    "dutch-grand-prix": "🇳🇱",
    "zandvoort": "🇳🇱",
    "italian-grand-prix": "🇮🇹",
    "italian": "🇮🇹",
    "azerbaijan-grand-prix": "🇦🇿",
    "azerbaijan": "🇦🇿",
    "singapore-grand-prix": "🇸🇬",
    "singapore": "🇸🇬",
    "us-grand-prix": "🇺🇸",
    "mexico-grand-prix": "🇲🇽",
    "brazilian-grand-prix": "🇧🇷",
    "las-vegas-grand-prix": "🇺🇸",
    "qatar-grand-prix": "🇶🇦",
    "qatar": "🇶🇦",
    "abu-dhabi-grand-prix": "🇦🇪",
    "abu-dhabi": "🇦🇪"
]

enum AppDataError: Error {
    case fetchError(String)
    case URLError(String)
}

enum SessionStatus: String {
    case finished = "Finished"
    case ongoing = "Ongoing"
    case upcoming = "Upcoming"
}

struct RawAPIData: Codable {
    struct Config: Codable {
        var availableYears: [Int]
        var sessions: [String]
        var sessionLengths: [String: Int]
    }
    
    struct Races: Codable {
        struct Race: Codable {
            var name: String
            var location: String
            var latitude: Double
            var longitude: Double
            var slug: String
            var sessions: [String: String]
        }
        
        var races: [RawAPIData.Races.Race]
    }
}

struct SeasonData: Codable {
    var year: Int = 2024
    var races: [RaceData] = [RaceData()]
}

struct RaceData: Codable {
    var name: String = "Preview Race"
    var location: String = "Preview Location"
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var sessions: [SessionData] = [SessionData()]
    var slug: String = "preview-grand-prix"

    // MARK: Computed Properties
    var coords: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    var flag: String {
        flags[self.slug] ?? ""
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
    var pastSessions: [SessionData] {
        sessions.filter { session in
            return session.endDate < Date()
        }
    }
    
    var ongoingSessions: [SessionData] {
        sessions.filter { session in
            return session.startDate < Date() && session.endDate >= Date()
        }
    }

    var futureSessions: [SessionData] {
        sessions.filter { session in
            return session.startDate >= Date()
        }
    }
}

struct SessionData: Codable {
    var rawName: String = "fp1"
    var startDate: Date = Date()
    var endDate: Date = Date().addingTimeInterval(600)
    
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
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: startDate)
    }
    
    var timeString: String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: startDate)
    }
    
    var dayString: String {
        let dateFormatter = DateFormatter()
        
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

@Model
class SeriesData {
    var series: String
    var seasons: [SeasonData]
    var config: RawAPIData.Config
    
    init(series: String, seasons: [SeasonData], config: RawAPIData.Config) {
        self.series = series
        self.seasons = seasons
        self.config = config
    }
}
