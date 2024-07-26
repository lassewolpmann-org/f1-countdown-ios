//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

enum SessionStatus: String {
    case finished, ongoing, upcoming
}

struct TimerTab: View {
    var appData: AppData;

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if let nextRace = appData.nextRace {
                    VStack(alignment: .center, spacing: 15) {
                        ForEach(nextRace.sortedSessions, id: \.key) { session in
                            if (session.value.endDate < Date()) {
                                // Session is in past
                                // Calculate to current date to instantly set delta to 0
                                let delta = DeltaValues(date: Date.now)
                                Session(appData: appData, nextRace: nextRace, session: session.value, status: .finished, delta: delta)
                            } else if (session.value.startDate < Date() && session.value.endDate >= Date()) {
                                // Session is ongoing
                                let delta = DeltaValues(date: session.value.endDate)
                                Session(appData: appData, nextRace: nextRace, session: session.value, status: .ongoing, delta: delta)
                            } else {
                                // Session is in future
                                let delta = DeltaValues(date: session.value.startDate)
                                Session(appData: appData, nextRace: nextRace, session: session.value, status: .upcoming, delta: delta)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .navigationTitle(getRaceTitle(race: nextRace))
                } else {
                    Label {
                        Text("It seems like there is no data available to display here.")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .bold()
                    .symbolRenderingMode(.multicolor)
                    .navigationTitle("Timer")
                }
            }
            .background(
                GeometryReader { geo in
                    if let flag = appData.nextRace?.flag {
                        Text(flag)
                            .font(.system(size: 1000))
                            .minimumScaleFactor(0.005)
                            .lineLimit(1)
                            .frame(width: geo.size.width, height: geo.size.height)
                            .rotationEffect(.degrees(90))
                            .blur(radius: 50)
                    }
                }
            )
        }
        .refreshable {
            do {
                try await appData.loadAPIData()
            } catch {
                print("\(error), while refreshing TimerTab")
            }
        }
    }
}

#Preview {
    TimerTab(appData: AppData())
}
