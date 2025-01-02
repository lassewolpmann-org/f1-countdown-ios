//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI
import SwiftData
import WidgetKit

struct TimerTab: View {
    @Query var allRaces: [RaceData]
    @State var currentDate: Date = .now
    
    var nextRace: RaceData? {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: .now)
        let currentSeries = allRaces.filter { $0.series == selectedSeries }
        let currentSeason = currentSeries.filter { $0.season == currentYear }
        let futureRaces = currentSeason.filter { $0.endDate > currentDate }
        let sortedRaces = futureRaces.sorted { $0.startDate < $1.startDate }
        
        return sortedRaces.first
    }
    
    let selectedSeries: String
    let notificationController: NotificationController
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if let nextRace {
                    VStack(alignment: .center, spacing: 15) {
                        ForEach(nextRace.race.sessions, id: \.shortName) { session in
                            let delta = getDelta(session: session)
                            Session(delta: delta, nextRace: nextRace, session: session, currentDate: currentDate, notificationController: notificationController)
                        }
                    }
                    .background(FlagBackground(flag: nextRace.race.flag))
                    .padding(.horizontal, 10)
                    .navigationTitle(nextRace.race.title)
                } else {
                    Label {
                        Text("It seems like there is no data available to display here.")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .bold()
                    .symbolRenderingMode(.multicolor)
                    .navigationTitle("Timer")
                }
            }
        }
        .onAppear {
            guard let nextRace else { return }
            
            for session in nextRace.race.sessions {
                DispatchQueue.main.asyncAfter(deadline: .now() + session.startDate.timeIntervalSinceNow) {
                    currentDate = .now
                    WidgetCenter.shared.reloadAllTimelines()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + session.endDate.timeIntervalSinceNow) {
                    currentDate = .now
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
        .refreshable {
            currentDate = Date()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview(traits: .sampleData) {
    TimerTab(selectedSeries: "f1", notificationController: NotificationController())
}
