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
        NavigationLink {
            ScrollView {
                VStack {
                    ForEach(nextRace.ongoingSessions, id: \.key) { session in
                        let delta = DeltaValues(date: session.value.endDate)
                        Session(appData: appData, nextRace: nextRace, session: session.value, delta: delta)
                    }
                }
                .padding(.horizontal, 10)
                .navigationTitle("Ongoing Sessions")
            }
        } label: {
            Label {
                Text("Ongoing Sessions")
            } icon: {
                Image(systemName: "clock")
            }
        }
    }
}

#Preview {
    NavigationStack {
        OngoingSessions(appData: AppData(), nextRace: RaceData())
    }
}
