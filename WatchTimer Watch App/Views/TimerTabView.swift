//
//  TimerTabView.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 2.1.2025.
//

import SwiftUI
import SwiftData

struct TimerTabView: View {
    @Query var allRaces: [RaceData]
    @State var currentDate: Date = .now
    @State var selectedSeries: String = "f1"
    
    var nextRace: RaceData? {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: .now)
        let currentSeries = allRaces.filter { $0.series == selectedSeries }
        let currentSeason = currentSeries.filter { $0.season == currentYear }
        let futureRaces = currentSeason.filter { $0.endDate > currentDate }
        let sortedRaces = futureRaces.sorted { $0.startDate < $1.startDate }
        
        return sortedRaces.first
    }
    
    var body: some View {
        TabView {
            if let nextRace {
                ForEach(nextRace.race.futureSessions, id: \.shortName) { session in
                    Session(session: session, delta: getDelta(session: session), selectedSeries: $selectedSeries, race: nextRace.race)
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
        .onAppear {
            guard let nextRace else { return }
            
            for session in nextRace.race.sessions {
                DispatchQueue.main.asyncAfter(deadline: .now() + session.startDate.timeIntervalSinceNow) {
                    currentDate = .now
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + session.endDate.timeIntervalSinceNow) {
                    currentDate = .now
                }
            }
        }
    }
}

#Preview(traits: .sampleData) {
    TimerTabView()
}
