//
//  OngoingSessions.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 28.6.2024.
//

import SwiftUI

struct OngoingSessions: View {
    var appData: AppData
    let nextRace: RaceData

    var body: some View {
        ForEach(nextRace.ongoingSessions, id: \.key) { session in
            let delta = DeltaValues(date: session.value.endDate)
            Session(appData: appData, nextRace: nextRace, session: session.value, status: .ongoing, delta: delta)
        }
    }
}

#Preview {
    NavigationStack {
        OngoingSessions(appData: AppData(), nextRace: RaceData())
    }
}
