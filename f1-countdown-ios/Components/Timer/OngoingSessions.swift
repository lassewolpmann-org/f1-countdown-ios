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

    @State var showOngoingSessions = false

    var body: some View {
        HStack {
            let ongoingSessionCount = nextRace.ongoingSessions.count
            Text("\(ongoingSessionCount) Ongoing \(ongoingSessionCount == 1 ? "Session" : "Sessions")")
                .font(.subheadline)
                .bold()
            
            Button {
                showOngoingSessions.toggle()
            } label: {
                Image(systemName: "eye.slash.circle")
                    .hidden()
                    .overlay {
                        Image(systemName:
                                showOngoingSessions ?
                              "eye.slash.circle" :
                                "eye.circle"
                        )
                    }
            }
        }
                                
        if (showOngoingSessions) {
            if (nextRace.ongoingSessions.isEmpty) {
                Label {
                    Text("No ongoing Sessions")
                } icon: {
                    Image(systemName: "clock.badge.exclamationmark")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.multicolor)
                .padding(10)
                .background(.ultraThinMaterial, in:
                    RoundedRectangle(cornerRadius: 10)
                )
            } else {
                ForEach(nextRace.ongoingSessions, id: \.key) { session in
                    let delta = DeltaValues(date: session.value.endDate)
                    Session(appData: appData, nextRace: nextRace, session: session.value, delta: delta)
                }
            }
        }
    }
}

#Preview {
    OngoingSessions(appData: AppData(), nextRace: RaceData())
}
