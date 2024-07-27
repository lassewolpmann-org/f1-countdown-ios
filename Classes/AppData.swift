//
//  AppData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.2.2024.
//

import Foundation

struct Races: Decodable {
    var races: [RaceData];
}

struct Config: Decodable {
    var sessionLengths: [String: Int]
}

enum AppDataError: Error {
    case fetchError(String)
    case URLError(String)
}

@Observable class AppData {
    let availableSeries: [String] = ["f1", "f2", "f3", "f1-academy"]
    let notificationOffsetOptions = [0, 5, 10, 15, 30, 60]

    var currentSeries: String
    var seriesData: [String: [RaceData]]
    var sessionLengths: [String: [String: Int]]
    var dataLoaded: Bool
    var calendarSearchFilter = ""
    
    // MARK: Init Class
    init() {
        self.currentSeries = availableSeries.first ?? "f1"
        self.seriesData = [:]
        self.sessionLengths = [:]
        self.dataLoaded = false
        
        Task {
            do {
                try await self.loadAPIData()
                
                if (!seriesData.isEmpty && !sessionLengths.isEmpty) {
                    self.dataLoaded = true
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Loading Functions
    func loadAPIData() async throws -> Void {
        for series in availableSeries {
            let baseURL = "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(series)"
            
            self.sessionLengths[series] = try await loadSessionsLenghts(url: baseURL)
            self.seriesData[series] = try await loadRaces(url: baseURL, series: series)
        }
    }
    
    func loadSessionsLenghts(url: String) async throws -> [String: Int] {
        guard let configURL = URL(string: "\(url)/config.json") else { throw AppDataError.URLError("Could not create Config URL string") }

        let (data, _) = try await URLSession.shared.data(from: configURL)
        let config = try JSONDecoder().decode(Config.self, from: data)
        
        return config.sessionLengths
    }
    
    func loadRaces(url: String, series: String) async throws -> [RaceData] {
        let date = Date.now
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        guard let racesURL = URL(string: "\(url)/\(year).json") else { throw AppDataError.URLError("Could not create Races URL string") }

        let (data, _) = try await URLSession.shared.data(from: racesURL)
        var races = try JSONDecoder().decode(Races.self, from: data).races
        
        // Add extra information to races
        races = races.map { race in
            var race = race
            race.sessionLengths = self.sessionLengths[series]
            
            return race
        }
        
        return races
    }
    
    // MARK: Computed properties
    var currentData: [RaceData] {
        return self.seriesData[self.currentSeries] ?? []
    }
    
    var nextRaces: [RaceData] {
        let nextRaces = self.currentData.filter { race in
            let lastSessionEndDate = race.sortedSessions.last?.value.endDate ?? Date()
            
            return lastSessionEndDate > Date()
        }
        
        return nextRaces
    }
    
    var nextRace: RaceData? {
        return self.nextRaces.first
    }
    
    var filteredRaces: [RaceData] {
        nextRaces.filter { race in
            if (self.calendarSearchFilter.isEmpty) { return true }
            
            let raceName = race.name.lowercased()
            let locationName = race.location.lowercased()
            let input = self.calendarSearchFilter.lowercased()
            
            return raceName.contains(input) || locationName.contains(input)
        }
    }
}
