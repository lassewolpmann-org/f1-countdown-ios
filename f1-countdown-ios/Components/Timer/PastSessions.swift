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
    @State var showFinishedSessions = false

    var body: some View {
        HStack {
            let finishedSessionCount = nextRace.pastSessions.count
            
            Text("\(finishedSessionCount) Finished \(finishedSessionCount == 1 ? "Session" : "Sessions")")
                .font(.subheadline)
                .bold()
            
            Button {
                showFinishedSessions.toggle()
            } label: {
                Image(systemName: "eye.slash.circle")
                    .hidden()
                    .overlay {
                        Image(systemName:
                            showFinishedSessions ?
                              "eye.slash.circle" :
                                "eye.circle"
                        )
                    }
            }
        }
        
        if (showFinishedSessions) {
            if (nextRace.pastSessions.isEmpty) {
                Label {
                    Text("No finished Sessions")
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
                ForEach(nextRace.pastSessions, id: \.key) { session in
                    let delta = DeltaValues(date: Date())
                    Session(appData: appData, nextRace: nextRace, session: session.value, delta: delta)
                }
            }
        }
    }
}

#Preview {
    PastSession(appData: AppData(), nextRace: RaceData())
}
