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
let flags: [String: String] = [
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
    "mexican-grand-prix": "🇲🇽",
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

func loadSeriesConfig(baseURL: String) async throws -> RawAPIData.Config {
    guard let configURL = URL(string: "\(baseURL)/config.json") else { throw AppDataError.URLError("Could not create Config URL string") }

    let (data, _) = try await URLSession.shared.data(from: configURL)
    return try JSONDecoder().decode(RawAPIData.Config.self, from: data)
}

func loadSeasonData(baseURL: String, year: Int, sessionLengths: [String: Int]) async throws -> Season {
    guard let racesURL = URL(string: "\(baseURL)/\(year).json") else { throw AppDataError.URLError("Could not create Season URL string") }

    let (data, _) = try await URLSession.shared.data(from: racesURL)
    let rawRaces = try JSONDecoder().decode(RawAPIData.Races.self, from: data).races
    
    let parsedRaces: [Season.Race] = rawRaces.compactMap { rawRace in
        let sessions: [Season.Race.Session] = rawRace.sessions.compactMap { rawSession in
            let start = rawSession.value
            guard let startDate = ISO8601DateFormatter().date(from: start) else { return nil }
            guard let sessionLength = sessionLengths[rawSession.key] else { return nil }
            let endDate = startDate.addingTimeInterval(TimeInterval(sessionLength * 60))
            
            return Season.Race.Session(rawName: rawSession.key, startDate: startDate, endDate: endDate, status: getSessionStatus(startDate: startDate, endDate: endDate))
        }.sorted { $0.startDate < $1.startDate }
        
        return Season.Race(name: rawRace.name, location: rawRace.location, latitude: rawRace.latitude, longitude: rawRace.longitude, sessions: sessions, slug: rawRace.slug)
    }
    
    return Season(year: year, races: parsedRaces)
}

@Model
class SeriesData {
    var series: String
    var seasons: [Season]
    var config: RawAPIData.Config
    
    var nextRace: Season.Race? {
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
    
    init(series: String, seasons: [Season], config: RawAPIData.Config) {
        self.series = series
        self.seasons = seasons
        self.config = config
    }
}
