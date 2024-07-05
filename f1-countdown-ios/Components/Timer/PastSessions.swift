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
        NavigationLink {
            ScrollView {
                VStack {
                    ForEach(nextRace.pastSessions, id: \.key) { session in
                        // Calculate to current date to instantly set delta to 0
                        let delta = DeltaValues(date: Date.now)
                        Session(appData: appData, nextRace: nextRace, session: session.value, delta: delta)
                    }
                }
                .padding(.horizontal, 10)
                .navigationTitle("Past Sessions")
            }
        } label: {
            Label {
                Text("Past Sessions")
            } icon: {
                Image(systemName: "rectangle.checkered")
            }
        }
    }
}

#Preview {
    NavigationStack {
        PastSession(appData: AppData(), nextRace: RaceData())
    }
}
