//
//  ContentView.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct ContentView: View {
    var appData: AppData
    var userDefaults: UserDefaultsController
    var notificationController: NotificationController
    
    var body: some View {
        TabView {
            let nextRace = appData.nextRace ?? RaceData()
            
            /*
            ForEach(nextRace.pastSessions, id: \.key) { session in
                let sessionName = parseShortSessionName(sessionName: session.key)
                Session(appData: appData, nextRace: nextRace, session: session.value, name: sessionName, delta: session.value.delta)
            }
            
            ForEach(nextRace.ongoingSessions, id: \.key) { session in
                let sessionName = parseShortSessionName(sessionName: session.key)
                Session(appData: appData, nextRace: nextRace, session: session.value, name: sessionName, delta: session.value.delta)
            }
             */
            
            ForEach(nextRace.futureSessions, id: \.key) { session in
                let sessionName = parseShortSessionName(sessionName: session.key)
                Session(appData: appData, nextRace: nextRace, session: session.value, name: sessionName, delta: DeltaValues(date: session.value.startDate))
            }
        }
        .tabViewStyle(.verticalPage)
    }
}

#Preview {
    ContentView(appData: AppData(), userDefaults: UserDefaultsController(), notificationController: NotificationController())
}
