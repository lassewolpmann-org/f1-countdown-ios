//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTab: View {
    var appData: AppData
    var notificationController: NotificationController
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if let nextRace = appData.nextRace {
                    VStack(alignment: .center, spacing: 15) {
                        ForEach(nextRace.pastSessions, id: \.shortName) { session in
                            // Calculate to current date to instantly set delta to 0
                            let delta = DeltaValues(date: Date.now)
                            
                            Session(appData: appData, notificationController: notificationController, nextRace: nextRace, session: session, delta: delta)
                        }
                        
                        ForEach(nextRace.ongoingSessions, id: \.shortName) { session in
                            // Calculate to end date
                            let delta = DeltaValues(date: session.endDate)
                            
                            Session(appData: appData, notificationController: notificationController, nextRace: nextRace, session: session, delta: delta)
                        }
                        
                        ForEach(nextRace.futureSessions, id: \.shortName) { session in
                            // Calculate to start date
                            let delta = DeltaValues(date: session.startDate)
                            
                            Session(appData: appData, notificationController: notificationController, nextRace: nextRace, session: session, delta: delta)
                        }
                    }
                    .background(FlagBackground(flag: nextRace.flag))
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
