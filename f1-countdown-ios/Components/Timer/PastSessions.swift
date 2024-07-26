//
//  PastSession.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 28.6.2024.
//

import SwiftUI

struct PastSession: View {
    var appData: AppData
    let nextRace: RaceData

    var body: some View {
        ForEach(nextRace.pastSessions, id: \.key) { session in
            // Calculate to current date to instantly set delta to 0
            let delta = DeltaValues(date: Date.now)
            Session(appData: appData, nextRace: nextRace, session: session.value, status: .finished, delta: delta)
        }
    }
}

#Preview {
    NavigationStack {
        PastSession(appData: AppData(), nextRace: RaceData())
    }
}
