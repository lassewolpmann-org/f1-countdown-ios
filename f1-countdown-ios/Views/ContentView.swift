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
                            if let existingSeriesData = allSeries.first(where: { $0.series == series }) {
                                let storedYears = existingSeriesData.seasons.map { $0.year }
                                let missingYears = existingSeriesData.config.availableYears.filter { !storedYears.contains($0) }
                                
                                for year in missingYears {
                                    let seasonData = try await loadSeasonData(baseURL: baseURL, year: year, sessionLengths: existingSeriesData.config.sessionLengths)
                                    existingSeriesData.seasons.append(Season(year: year, races: seasonData.races))
                                }
                            } else {
                                let seriesConfig = try await loadSeriesConfig(baseURL: baseURL)

                                // MARK: If series data does not exist yet
                                var allSeasons: [Season] = []
                                
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
}

#Preview(traits: .sampleData) {
    ContentView(notificationController: NotificationController())
}
