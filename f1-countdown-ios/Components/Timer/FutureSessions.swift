//
//  FutureSessions.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 28.6.2024.
//

import SwiftUI

struct FutureSessions: View {
    var appData: AppData
    let nextRace: RaceData
    
    var body: some View {
        let upcomingSessionCount = nextRace.futureSessions.count
        
        Text("\(upcomingSessionCount) Upcoming \(upcomingSessionCount == 1 ? "Session" : "Sessions")")
            .font(.subheadline)
            .bold()

        ForEach(nextRace.futureSessions, id: \.key) { session in
            let delta = DeltaValues(date: session.value.startDate)
            Session(appData: appData, nextRace: nextRace, session: session.value, delta: delta)
        }
    }
}

#Preview {
    FutureSessions(appData: AppData(), nextRace: RaceData())
}
