//
//  APICaller.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

struct APIConfig: Decodable {
    var availableYears: [Int] = [1970]
    var sessions: [String] = ["undefined 1", "undefined 2"]
    var sessionLengths: [String: Int] = ["undefined 1": 60, "undefined 2": 30]
}

struct APIData: Decodable {
    let races: [RaceData]
}

struct RaceData: Decodable, Identifiable, Hashable {
    var name: String = "undefined"
    var location: String = "undefined place"
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var round: Int = 0
    var slug: String = "undefined-grand-prix"
    var localeKey: String = "undefined-grand-prix"
    var sessions: [String: String] = ["fp1": "2024-01-01T00:00:00Z", "sprintQualifying": "2024-01-02T00:00:00Z", "gp": "2024-01-03T00:00:00Z"]
    
    var id: String {
        name
    }
}

import Foundation

func callAPI(year: Int) async throws -> [RaceData] {
    let series = "f1";
    
    guard let url = URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(series)/\(year).json") else {
        return [RaceData]()
    };
    
    let request  = URLRequest(url: url);
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request);
        let fetchedData = try JSONDecoder().decode(APIData.self, from: data);
        
        return getNextRaces(races: fetchedData.races)
    } catch {
        print("Error calling API!")
        print(error)
        
        return [RaceData]()
    }
}

func getAPIConfig() async throws -> APIConfig {
    let series = "f1";
    
    guard let url = URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(series)/config.json") else {
        return APIConfig()
    };
    
    let request  = URLRequest(url: url);
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request);
        let config = try JSONDecoder().decode(APIConfig.self, from: data);
        
        return config
    } catch {
        print("Error calling API!")
        print(error)
        
        return APIConfig()
    }
}

func getNextRaces(races: [RaceData]) -> [RaceData] {
    let nextRaces = races.filter { race in
        let raceSessions = race.sessions;
        let raceSessionDates = raceSessions.values;
        guard let raceDate = raceSessionDates.sorted().last else {
            return false
        };
        
        let formatter = ISO8601DateFormatter();
        let date = formatter.date(from: raceDate)!;
        
        return date.timeIntervalSinceNow > 0
    }
    
    return nextRaces
}
