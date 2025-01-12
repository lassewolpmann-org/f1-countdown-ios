//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var allRaces: [RaceData]
    
    @State var loadingData = true
    @State var selectedSeries: String = "f1"
    
    // var appData: AppData
    var notificationController: NotificationController
    
    var body: some View {
        if (loadingData) {
            ProgressView("Loading data...")
                .task {
                    for series in availableSeries {
                        let baseURL = "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(series)"
                        
                        do {
                            guard let configURL = URL(string: "\(baseURL)/config.json") else { throw AppDataError.URLError("Could not create Config URL string") }
                            let (data, _) = try await URLSession.shared.data(from: configURL)
                            let config = try JSONDecoder().decode(RawAPIData.Config.self, from: data)
                            
                            for year in config.yearsToParse {
                                guard let racesURL = URL(string: "\(baseURL)/\(year).json") else { throw AppDataError.URLError("Could not create Season URL string") }

                                let (data, _) = try await URLSession.shared.data(from: racesURL)
                                let rawRaces = try JSONDecoder().decode(RawAPIData.Races.self, from: data).races
                                rawRaces.forEach { newRace in
                                    let parsedRace = parseRace(rawRace: newRace, sessionLengths: config.sessionLengths)
                                    
                                    if let existingRace = allRaces.first(where: {
                                        $0.season == year && $0.series == series && $0.race.slug == newRace.slug
                                    }) {
                                        // Check if notification times changes, if yes -> update notifications
                                        let sessions = existingRace.race.sessions
                                        // print(parsedRace.sessions == sessions)
                                        
                                        // Update locally stored information
                                        existingRace.race = parsedRace
                                    } else {
                                        // New race, inserting info
                                        context.insert(RaceData(series: series, season: year, race: parsedRace))
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                    do {
                        try context.save()
                    } catch {
                        print(error)
                    }
                    
                    loadingData = false
                }
        } else {
            TabView {
                Tab {
                    TimerTab(selectedSeries: selectedSeries, notificationController: notificationController)
                } label: {
                    Label("Timer", systemImage: "stopwatch")
                }
                
                Tab {
                    CalendarTab(selectedSeries: selectedSeries)
                } label: {
                    Label("Upcoming", systemImage: "calendar")
                }
                
                Tab {
                    SettingsTab(selectedSeries: $selectedSeries, notificationController: notificationController)
                } label: {
                    Label("Settings", systemImage: "gear")
                }
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

#Preview(traits: .sampleData) {
    ContentView(notificationController: NotificationController())
}
