//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI
import SwiftData

struct CalendarTab: View {
    @Query var allSeries: [SeriesData]
    
    let selectedSeries: String
    
    var currentSeason: SeasonData? {
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: Date.now)
        
        guard let currentSeries = allSeries.first(where: { $0.series == selectedSeries }) else { return nil }
        guard let currentSeason = currentSeries.seasons.first(where: { $0.year == year }) else { return nil }
        guard let lastRaceEndDate = currentSeason.races.last?.sessions.last?.endDate else { return nil }
        
        if lastRaceEndDate > Date.now {
            return currentSeason
        } else {
            if (!currentSeries.config.availableYears.contains(year + 1)) { return nil }
            return currentSeries.seasons.first(where: { $0.year == year + 1 })
        }
    }
    
    var filteredRaces: [RaceData] {
        guard let allRaces = currentSeason?.races else { return [] }
        
        if (searchFilter.isEmpty) { return allRaces }
        
        return allRaces.filter { $0.name.localizedStandardContains(searchFilter) || $0.location.localizedStandardContains(searchFilter) }
    }
    
    @State private var searchFilter: String = ""
    
    var body: some View {
        NavigationStack {
            if (currentSeason == nil) {
                Label {
                    Text("It seems like there is no data available to display here.")
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                .bold()
                .symbolRenderingMode(.multicolor)
                .navigationTitle("Upcoming Races")
            } else {
                ScrollView {
                    ForEach(filteredRaces, id: \.slug) { race in
                        UpcomingTabRaceView(race: race)
                    }
                }
                .padding(.horizontal)
                .searchable(text: $searchFilter)
                .navigationTitle("Upcoming Races")
            }
        }
    }
}

#Preview(traits: .sampleData) {
    CalendarTab(selectedSeries: "f1")
}
