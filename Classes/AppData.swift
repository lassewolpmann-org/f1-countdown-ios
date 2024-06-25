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
    var series = "f1"
    var races: [RaceData]?
    var dataLoaded = false
    var calendarSearchFilter = ""
    
    func getAllRaces() async throws -> [RaceData] {
        let date = Date();
        let calendar = Calendar.current;
        let year = calendar.component(.year, from: date);
        
        guard let url = URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(self.series)/\(year).json") else { throw AppDataError.URLError("Could not create API URL string") }
        
        let (data, _) = try await URLSession.shared.data(from: url);
        var races = try JSONDecoder().decode(API.self, from: data).races
        
        races = races.map { race in
            var race = race
            race.series = self.series
            
            return race
        }
        
        return races
    }
    
    var nextRaces: [RaceData] {
        let nextRaces = self.races?.filter { race in
            let lastSessionEndDate = race.sortedSessions.last?.value.endDate ?? Date()
            
            return lastSessionEndDate > Date()
        }
        
        return nextRaces ?? []
    }
    
    var nextRace: RaceData? {
        return self.nextRaces.first
    }
    
    var nextRaceSessions: Array<(key: String, value: SessionData)> {
        if let sessions = nextRace?.sessions {
            var sessionData: [String: SessionData] = [:]
            
            for session in sessions {
                let name = session.key
                let startDateString = session.value
                let sessionLength = SessionLengths().series[self.series]?[name] ?? 0 // Value is in minutes
                
                let formatter = ISO8601DateFormatter()
                
                let startDate = formatter.date(from: startDateString)
                let endDate = startDate?.addingTimeInterval(sessionLength * 60)
                
                if let startDate, let endDate {
                    let delta = DeltaValues(date: startDate)
                    sessionData[name] = SessionData(formattedName: parseSessionName(sessionName: name), startDate: startDate, endDate: endDate, delta: delta)
                }
            }
            
            return sessionData.sorted { a, b in
                a.value.startDate < b.value.startDate
            }
        } else {
            return []
        }
    }
    
    var filteredRaces: [RaceData] {
        nextRaces.filter { race in
            if (calendarSearchFilter == "") { return true }
            
            let raceName = race.name.lowercased()
            let locationName = race.location.lowercased()
            let input = calendarSearchFilter.lowercased()
            
            return raceName.contains(input) || locationName.contains(input)
        }
    }
}
