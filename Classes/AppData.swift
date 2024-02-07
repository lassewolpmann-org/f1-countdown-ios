//
//  AppData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.2.2024.
//

import Foundation

struct APIData: Decodable {
    let races: [RaceData]
}

class AppData {
    var nextRaces: [RaceData];
    
    init() {
        nextRaces = [RaceData()];
        print("Data init")
    }
    
    func getData(config: DataConfig) async {
        do {
            let date = Date();
            let calendar = Calendar.current;
            var year = calendar.component(.year, from:date);
            
            self.nextRaces = try await self.callAPI(year: year);
            if (self.nextRaces.isEmpty) {
                year += 1;
                
                if (config.availableYears.contains(year)) {
                    self.nextRaces = try await self.callAPI(year: year);
                } else {
                    self.nextRaces = [RaceData()];
                }
            }
        } catch {
            print("Error calling API")
        }
    }
    
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
    
    func getNextRaces(races: [RaceData]) -> [RaceData] {
        let nextRaces = races.filter { race in
            let raceSessions = race.sessions.sorted(by:{$0.value < $1.value});
            let date = ISO8601DateFormatter().date(from: raceSessions.last!.value)!;
            
            return date.timeIntervalSinceNow > 0
        }
        
        return nextRaces
    }
}
