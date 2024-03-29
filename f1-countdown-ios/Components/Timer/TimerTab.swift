//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTab: View {
    @Environment(AppData.self) private var appData;

    var body: some View {
        NavigationStack {
            ScrollView {
                ForEach(appData.nextRace.futureSessions, id: \.key) { key, value in
                    Session(sessionName: key, sessionDate: value, delta: deltaValues(dateString: value))
                        .environment(appData)
                }
            }
            .navigationTitle(getRaceTitle(race: appData.nextRace))
        }
        .refreshable {
            do {
                appData.races = try await appData.getAllRaces()
            } catch {
                print("\(error), while refreshing TimerTab")
            }
        }
    }
}

#Preview {
    TimerTab()
        .environment(AppData(series: "f1"))
}
