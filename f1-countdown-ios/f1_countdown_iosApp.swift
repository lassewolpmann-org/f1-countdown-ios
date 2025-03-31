//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

@main
struct f1_countdown_iosApp: App {
    @State private var notificationController: NotificationController = NotificationController()
    @State var loadingData: Bool = true
    @State var allRaces: [String: [RaceData]] = [:]
    
    var body: some Scene {
        WindowGroup {
            if (loadingData) {
                ProgressView("Loading data...")
                    .task {
                        for series in availableSeries {
                            let baseURL = "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(series)"
                            
                            do {
                                guard let configURL = URL(string: "\(baseURL)/config.json") else { throw AppDataError.URLError("Could not create Config URL string") }
                                let (configData, _) = try await URLSession.shared.data(from: configURL)
                                let config = try JSONDecoder().decode(RawAPIData.Config.self, from: configData)
                                
                                guard let seasonDataURL = URL(string: "\(baseURL)/\(config.yearToLoad).json") else { throw AppDataError.URLError("Could not create Season URL string") }
                                let (seasonData, _) = try await URLSession.shared.data(from: seasonDataURL)
                                let rawRaces = try JSONDecoder().decode(RawAPIData.Races.self, from: seasonData).races
                                let seriesRaces = rawRaces.map { rawRace in
                                    let parsedRace = parseRace(rawRace: rawRace, sessionLengths: config.sessionLengths)
                                    return RaceData(series: series, season: config.yearToLoad, race: parsedRace, tbc: rawRace.tbc ?? false)
                                }
                                
                                allRaces[series] = seriesRaces
                            } catch {
                                print(error)
                            }
                        }
                        
                        loadingData = false
                    }
            } else {
                ContentView(allRaces: allRaces, notificationController: notificationController)
            }
        }
    }
    
    func parseRace(rawRace: RawAPIData.Races.Race, sessionLengths: [String: Int]) -> Season.Race {
        let sessions: [Season.Race.Session] = rawRace.sessions.compactMap { rawSession in
            let start = rawSession.value
            guard let startDate = ISO8601DateFormatter().date(from: start) else { return nil }
            guard let sessionLength = sessionLengths[rawSession.key] else { return nil }
            let endDate = startDate.addingTimeInterval(TimeInterval(sessionLength * 60))
            
            return Season.Race.Session(rawName: rawSession.key, startDate: startDate, endDate: endDate)
        }.sorted { $0.startDate < $1.startDate }
        
        return Season.Race(name: rawRace.name, location: rawRace.location, sessions: sessions, slug: rawRace.slug)
    }
}
