//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTab: View {
    let nextRace: RaceData;
    
    var body: some View {
        let flag = CountryFlags().flags[nextRace.localeKey] ?? "🏳️";
        let raceTitle = getRaceTitle(race: nextRace);
        let sessions = nextRace.sessions.sorted(by:{$0.value < $1.value}).filter { key, value in
            let date = ISO8601DateFormatter().date(from: value);
            
            return date!.timeIntervalSinceNow > 0
        };
        NavigationStack {
            List {
                ForEach(sessions, id: \.key) { key, value in
                    Session(name: key, date: value)
                }
            }.navigationTitle("\(flag) \(raceTitle)")
        }
    }
}

#Preview {
    TimerTab(nextRace: RaceData())
}
