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
    var appData: AppData
    var notificationController: NotificationController
    
    @State private var notificationsEnabled: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if let nextRace = appData.nextRace {
                    VStack(alignment: .center, spacing: 15) {
                        ForEach(nextRace.pastSessions, id: \.key) { session in
                            // Calculate to current date to instantly set delta to 0
                            let delta = DeltaValues(date: Date.now)
                            Session(appData: appData, notificationController: notificationController, nextRace: nextRace, session: session.value, status: .finished, delta: delta)
                        }
                        
                        ForEach(nextRace.ongoingSessions, id: \.key) { session in
                            let delta = DeltaValues(date: session.value.endDate)
                            Session(appData: appData, notificationController: notificationController, nextRace: nextRace, session: session.value, status: .ongoing, delta: delta)
                        }
                        
                        ForEach(nextRace.futureSessions, id: \.key) { session in
                            let delta = DeltaValues(date: session.value.startDate)
                            Session(appData: appData, notificationController: notificationController, nextRace: nextRace, session: session.value, status: .upcoming, delta: delta)
                        }
                    }
                    .padding(.horizontal, 10)
                    .navigationTitle(nextRace.title)
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
            .background(FlagBackground(flag: appData.nextRace?.flag ?? ""))
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
    let sessionLengths = ["fp1": 1, "sprintQualifying": 1, "sprint": 1, "qualifying": 1, "gp": 1]
    let data = AppData()
    data.currentSeries = "f1"
    data.sessionLengths = ["f1": sessionLengths]

    var raceData = RaceData()
    raceData.sessionLengths = sessionLengths
    
    data.seriesData = ["f1": [raceData]]
    data.dataLoaded = true
    
    return TimerTab(appData: data, notificationController: NotificationController())
}
