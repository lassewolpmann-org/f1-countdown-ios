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
        
        return allRaces.filter { $0.name.localizedStandardContains(searchFilter) }
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
                if (!filteredRaces.isEmpty) {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 15) {
                            ForEach(filteredRaces, id: \.slug) { race in
                                VStack(alignment: .center, spacing: 20) {
                                    Text(race.title)
                                        .font(.title2)
                                        .bold()
                                    
                                    ForEach(race.sessions, id: \.shortName) { session in
                                        VStack {
                                            HStack {
                                                Text(session.longName)
                                                    .foregroundStyle(.red)
                                                Spacer()
                                                Text(session.dayString)
                                                    .foregroundStyle(.secondary)
                                            }
                                            
                                            HStack {
                                                Text(session.dateString)
                                                Spacer()
                                                Text(DateInterval(start: session.startDate, end: session.endDate))
                                            }
                                        }
                                        .strikethrough(session.endDate.timeIntervalSinceNow < 0)
                                        .opacity(session.endDate.timeIntervalSinceNow < 0 ? 0.5 : 1.0)
                                    }
                                }
                                .padding(15)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
                                .background(FlagBackground(flag: race.flag))
                                .scrollTransition { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.5)
                                        .blur(radius: abs(phase.value))
                                }
                            }
                        }
                    }
                    .navigationTitle("Upcoming Races")
                } else {
                    Label {
                        Text("Couldn't find an event matching your search.")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .bold()
                    .symbolRenderingMode(.multicolor)
                    .navigationTitle("Upcoming Races")
                }
            }
        }
        .searchable(text: $searchFilter)
    }
}

#Preview {
    CalendarTab(selectedSeries: "f1")
}
