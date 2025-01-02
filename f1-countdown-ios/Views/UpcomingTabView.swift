//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI
import SwiftData

struct CalendarTab: View {
    @Query var allRaces: [RaceData]
    
    let selectedSeries: String
    
    var currentSeason: [RaceData] {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: .now)
        let currentSeries = allRaces.filter { $0.series == selectedSeries }
        let currentSeason = currentSeries.filter { $0.season == currentYear }
        let futureRaces = currentSeason.filter { $0.endDate > Date() }
        let sortedRaces = futureRaces.sorted { $0.startDate < $1.startDate }
        
        if (searchFilter.isEmpty) { return sortedRaces }
        
        return sortedRaces.filter { $0.race.name.localizedStandardContains(searchFilter) || $0.race.location.localizedStandardContains(searchFilter) }
    }

    @State private var searchFilter: String = ""
    
    var body: some View {
        NavigationStack {
            if (currentSeason.isEmpty) {
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
                    ForEach(currentSeason, id: \.race.slug) { race in
                        UpcomingTabRaceView(race: race.race)
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
