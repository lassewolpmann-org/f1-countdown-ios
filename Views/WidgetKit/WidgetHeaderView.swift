//
//  WidgetHeader.swift
//  TimerWidgetExtension
//
//  Created by Lasse Wolpmann on 27.2.2024.
//

import SwiftUI
import WidgetKit
import SwiftData

struct WidgetHeader: View {
    @Query var allSeries: [SeriesData]
    
    var nextRace: RaceData? {
        let currentSeries = allSeries.first { $0.series == "f1" }
        let currentSeason = currentSeries?.seasons.first { $0.year == 2024 }
        return currentSeason?.races.first
    }
    
    let entry: TimerEntry;
    
    var body: some View {
        HStack {
            Text(nextRace?.title ?? "")
                .font(.headline)
            
            Spacer()
        }
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(race: RaceData(), date: Date.now)
}
