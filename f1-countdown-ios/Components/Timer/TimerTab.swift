//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTab: View {
    @State var nextRace: RaceData;

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(nextRace.futureSessions, id: \.key) { key, value in
                    Session(nextRace: $nextRace, sessionName: key, sessionDate: value, delta: deltaValues(dateString: value))
                }
            }
            .navigationTitle(getRaceTitle(race: nextRace))
        }
        .refreshable {
            do {
                nextRace = try await AppData().nextRace;
            } catch {
                print("Error getting next Race")
            }
        }
    }
}

#Preview {
    TimerTab(nextRace: RaceData())
}
