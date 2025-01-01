//
//  ContentView.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query var allSeries: [SeriesData]
    
    @State var loadingData: Bool = true
    @State var selectedSeries: String = "f1"
    
    var currentSeries: SeriesData? { allSeries.filter({ $0.series == selectedSeries }).first }
    
    let notificationController: NotificationController
    
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
                if let nextRace = currentSeries?.nextRace {
                    ForEach(nextRace.futureSessions, id: \.shortName) { session in
                        Session(session: session, delta: getDelta(session: session), selectedSeries: $selectedSeries, race: nextRace)
                    }
                } else {
                    VStack {
                        Text("No data available for \(selectedSeries.uppercased()).")

                        Picker(selection: $selectedSeries) {
                            ForEach(availableSeries, id:\.self) { series in
                                Text(series.uppercased())
                            }
                        } label: {
                            Text("Select Series")
                        }
                        .sensoryFeedback(.selection, trigger: selectedSeries)
                        .pickerStyle(.navigationLink)
                    }
                }
            }
            .tabViewStyle(.verticalPage)
        }
    }
}

#Preview(traits: .sampleData) {
    ContentView(notificationController: NotificationController())
}
