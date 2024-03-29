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

@Observable class AppData {
    var series: String = "f1";
    var races: [RaceData] = [RaceData()];
    
    init(series: String) {
        self.series = series;
    }
    
    func getAllRaces() async throws -> [RaceData] {
        let date = Date();
        let calendar = Calendar.current;
        let year = calendar.component(.year, from: date);
        
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(self.series)/\(year).json")!);
                
        return try JSONDecoder().decode(API.self, from: data).races
    }
    
    var nextRaces: [RaceData] {
        let allRaces = self.races;
        let nextRaces = allRaces.filter { race in
            let raceSessions = race.sessions.sorted(by:{$0.value < $1.value});
            let date = ISO8601DateFormatter().date(from: raceSessions.last!.value)!;
            
            return date.timeIntervalSinceNow > 0
        }
        
        if (nextRaces.isEmpty) {
            return [allRaces.last ?? RaceData()]
        } else {
            return nextRaces
        }
    }
    
    var nextRace: RaceData {
        return self.nextRaces.first ?? RaceData()
    }
}
