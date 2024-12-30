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
    @Query var allSeries: [SeriesData]
    
    @State var loadingData: Bool = true
    
    // var appData: AppData
    var notificationController: NotificationController
    
    var body: some View {
        if (loadingData) {
            ProgressView("Loading data...")
                .task {
                    for series in availableSeries {
                        let baseURL = "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(series)"
                        
                        do {
                            if let existingSeriesData = allSeries.first(where: { $0.series == series }) {
                                let storedYears = existingSeriesData.seasons.map { $0.year }
                                let missingYears = existingSeriesData.config.availableYears.filter { !storedYears.contains($0) }
                                
                                for year in missingYears {
                                    let seasonData = try await loadSeasonData(baseURL: baseURL, year: year, sessionLengths: existingSeriesData.config.sessionLengths)
                                    existingSeriesData.seasons.append(SeasonData(year: year, races: seasonData.races))
                                }
                            } else {
                                let seriesConfig = try await loadSeriesConfig(baseURL: baseURL)

                                // MARK: If series data does not exist yet
                                var allSeasons: [SeasonData] = []
                                
                                for year in seriesConfig.availableYears {
                                    let seasonData = try await loadSeasonData(baseURL: baseURL, year: year, sessionLengths: seriesConfig.sessionLengths)
                                    allSeasons.append(seasonData)
                                }
                                
                                context.insert(SeriesData(series: series, seasons: allSeasons, config: seriesConfig))
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                    loadingData = false
                }
        } else {
            TabView {
                TimerTab(notificationController: notificationController)
                .tabItem {
                    Label("Timer", systemImage: "stopwatch")
                }
                
                CalendarTab()
                .tabItem {
                    Label("Upcoming", systemImage: "calendar")
                }
                
                SettingsTab(notificationController: notificationController)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
    }
    
    func loadSeriesConfig(baseURL: String) async throws -> RawAPIData.Config {
        guard let configURL = URL(string: "\(baseURL)/config.json") else { throw AppDataError.URLError("Could not create Config URL string") }

        let (data, _) = try await URLSession.shared.data(from: configURL)
        return try JSONDecoder().decode(RawAPIData.Config.self, from: data)
    }
    
    func loadSeasonData(baseURL: String, year: Int, sessionLengths: [String: Int]) async throws -> SeasonData {
        guard let racesURL = URL(string: "\(baseURL)/\(year).json") else { throw AppDataError.URLError("Could not create Season URL string") }

        let (data, _) = try await URLSession.shared.data(from: racesURL)
        let rawRaces = try JSONDecoder().decode(RawAPIData.Races.self, from: data).races
        
        let parsedRaces: [RaceData] = rawRaces.compactMap { rawRace in
            let sessions: [SessionData] = rawRace.sessions.compactMap { rawSession in
                let start = rawSession.value
                guard let startDate = ISO8601DateFormatter().date(from: start) else { return nil }
                guard let sessionLength = sessionLengths[rawSession.key] else { return nil }
                let endDate = startDate.addingTimeInterval(TimeInterval(sessionLength))
                
                return SessionData(rawName: rawSession.key, startDate: startDate, endDate: endDate)
            }.sorted { $0.startDate < $1.startDate }
            
            return RaceData(name: rawRace.name, location: rawRace.location, latitude: rawRace.latitude, longitude: rawRace.longitude, sessions: sessions, slug: rawRace.slug)
        }
        
        return SeasonData(year: year, races: parsedRaces)
    }
}

#Preview {
    ContentView(notificationController: NotificationController())
}
