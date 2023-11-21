//
//  APICaller.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

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
    var sessions: [String: String] = ["Undefined 1": "2024-01-01T00:00:00Z", "Undefined 2": "2024-01-02T00:00:00Z", "Undefined 3": "2024-01-03T00:00:00Z"]
    
    var id: String {
        name
    }
}

import Foundation

func callAPI() async throws -> [RaceData] {
    let date = Date();
    let calendar = Calendar.current;
    let year = calendar.component(.year, from:date);
    
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
        
        return [RaceData]()
    }
}

func getNextRaces(races: [RaceData]) -> [RaceData] {
    let nextRaces = races.filter { race in
        let raceSessions = race.sessions;
        let raceSessionDates = raceSessions.values;
        guard let raceDate = raceSessionDates.sorted().last else {
            return false
        };
        
        return Date() < formatDate(dateString: raceDate)
    }
    
    if (nextRaces.isEmpty) {
        let lastRace = races.last!
        
        return [lastRace]
    } else {
        return nextRaces
    }
}
