//
//  API.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import Foundation

func callAPI(year: Int) async throws -> [RaceData] {
    guard let url = URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/f1/\(year).json") else {
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
    guard let url = URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/f1/config.json") else {
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
