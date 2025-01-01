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

func getSessionStatus(session: SessionData) -> SessionStatus {
    var status: SessionStatus {
        let date: Date = .now
        
        if (date >= session.endDate) {
            return SessionStatus.finished
        } else if (date >= session.startDate && date < session.endDate) {
            return SessionStatus.ongoing
        } else {
            return SessionStatus.upcoming
        }
    }
    
    return status
}


func loadSeriesConfig(baseURL: String) async throws -> RawAPIData.Config {
    guard let configURL = URL(string: "\(baseURL)/config.json") else { throw AppDataError.URLError("Could not create Config URL string") }

    let (data, _) = try await URLSession.shared.data(from: configURL)
    return try JSONDecoder().decode(RawAPIData.Config.self, from: data)
}

func loadSeasonData(baseURL: String, year: Int, sessionLengths: [String: Int]) async throws -> SeasonData {
    guard let racesURL = URL(string: "\(baseURL)/\(year).json") else { throw AppDataError.URLError("Could not create Season URL string") }

    let (data, _) = try await URLSession.shared.data(from: racesURL)
    let rawRaces = try JSONDecoder().decode(RawAPIData.Races.self, from: data).races
    
    let parsedRaces: [RaceData] = rawRaces.compactMap { rawRace in
        let sessions: [SessionData] = rawRace.sessions.compactMap { rawSession in
            let start = rawSession.value
            guard let startDate = ISO8601DateFormatter().date(from: start) else { return nil }
            guard let sessionLength = sessionLengths[rawSession.key] else { return nil }
            let endDate = startDate.addingTimeInterval(TimeInterval(sessionLength * 60))
            
            return SessionData(rawName: rawSession.key, startDate: startDate, endDate: endDate)
        }.sorted { $0.startDate < $1.startDate }
        
        return RaceData(name: rawRace.name, location: rawRace.location, latitude: rawRace.latitude, longitude: rawRace.longitude, sessions: sessions, slug: rawRace.slug)
    }
    
    return SeasonData(year: year, races: parsedRaces)
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
    var year: Int
    var races: [RaceData]
}

struct RaceData: Codable {
    var name: String
    var location: String
    var latitude: Double
    var longitude: Double
    var sessions: [SessionData]
    var slug: String

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
    var rawName: String
    var startDate: Date
    var endDate: Date
    
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
    
    var nextRace: RaceData? {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: Date.now)

        guard let currentSeason = self.seasons.first(where: { $0.year == year }) else { return nil }
        
        if let nextRace = currentSeason.races.filter({ race in
            guard let raceEndDate = race.sessions.last?.endDate else { return false }
            
            return raceEndDate > Date.now
        }).first {
            return nextRace
        } else {
            if (!self.config.availableYears.contains(year + 1)) { return nil }
            
            guard let nextSeason = self.seasons.first(where: { $0.year == year + 1 }) else { return nil }
            
            return nextSeason.races.filter { race in
                guard let raceEndDate = race.sessions.last?.endDate else { return false }
                
                return raceEndDate > Date.now
            }.first
        }
    }
    
    init(series: String, seasons: [SeasonData], config: RawAPIData.Config) {
        self.series = series
        self.seasons = seasons
        self.config = config
    }
}
