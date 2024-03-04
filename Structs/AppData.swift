//
//  AppData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.2.2024.
//

import Foundation

struct AppData: Decodable {
    var races: [RaceData] = [RaceData()]
    var series: String?;
    
    var data: AppData {
        get async throws {
            let date = Date();
            let calendar = Calendar.current;
            let year = calendar.component(.year, from: date);
            
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(series ?? "f1")/\(year).json")!);
            return try JSONDecoder().decode(AppData.self, from: data)
        }
    }
    
    var nextRaces: [RaceData] {
        get async throws {
            let allRaces = try await self.data.races;
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
    }
        
    var nextRace: RaceData {
        get async throws {
            return try await self.nextRaces.first ?? RaceData()
        }
    }
}
