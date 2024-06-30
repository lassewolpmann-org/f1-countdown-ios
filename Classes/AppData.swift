//
//  AppData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.2.2024.
//

import Foundation

struct API: Decodable {
    var races: [RaceData];
}

enum AppDataError: Error {
    case fetchError(String)
    case URLError(String)
}

@Observable class AppData {
    let availableSeries: [String] = ["f1", "f2", "f3"]
    var currentSeries: String
    var seriesData: [String: [RaceData]]
    var dataLoaded: Bool
    var calendarSearchFilter = ""
    
    var notificationOffsetOptions = [0, 5, 10, 15, 30, 60]
    var selectedOffsetOption: Int
    
    // MARK: Init Class
    init() {
        self.currentSeries = availableSeries.first ?? "f1"
        self.seriesData = [:]
        self.dataLoaded = false
        self.selectedOffsetOption = UserDefaults.standard.integer(forKey: "Notification")
        
        Task {
            do {
                try await self.loadAPIData()
                if (seriesData.isEmpty) {
                    print("No data.")
                } else {
                    self.dataLoaded = true
                }
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: Function for loading data from API
    func loadAPIData() async throws -> Void {
        let date = Date.now
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        
        for series in availableSeries {
            guard let url = URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(series)/\(year).json") else { throw AppDataError.URLError("Could not create API URL string") }
            let (data, _) = try await URLSession.shared.data(from: url)
            var races = try JSONDecoder().decode(API.self, from: data).races
            
            // Add extra information to races
            races = races.map { race in
                var race = race
                race.series = series
                
                return race
            }
            
            self.seriesData[series] = races
        }
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
            if (self.calendarSearchFilter == "") { return true }
            
            let raceName = race.name.lowercased()
            let locationName = race.location.lowercased()
            let input = self.calendarSearchFilter.lowercased()
            
            return raceName.contains(input) || locationName.contains(input)
        }
    }
}
