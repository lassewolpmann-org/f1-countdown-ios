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
    
    var currentSeason: SeasonData? {
        let currentSeries = allSeries.first { $0.series == "f1" }
        return currentSeries?.seasons.first { $0.year == 2024 }
    }
    
    @State private var searchFilter: String = ""
    
    var body: some View {
        NavigationStack {
            if let races = currentSeason?.races {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 15) {
                        ForEach(races, id: \.slug) { race in
                            CalendarRace(race: race)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.5)
                                    .blur(radius: abs(phase.value))
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal, 40, for: .scrollContent)
                .scrollTargetBehavior(.paging)
                .navigationTitle("Upcoming Races")
            } else {
                Text("No Races")
            }
        }
        .searchable(text: $searchFilter)
    }
}

#Preview {
    CalendarTab()
}
