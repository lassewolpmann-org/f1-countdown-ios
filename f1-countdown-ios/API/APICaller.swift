//
//  APICaller.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

struct APIData: Decodable {
    let races: [RaceData]
}

struct RaceData: Decodable {
    var name: String
    var location: String
    var latitude: Double
    var longitude: Double
    var round: Int
    var slug: String
    var localeKey: String
    var sessions: [String: String]
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
    
    return nextRaces
}
