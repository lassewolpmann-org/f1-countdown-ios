//
//  ContentView.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct ContentView: View {
    var notificationController: NotificationController
    
    var body: some View {
        Text("Test")
        /*
        TabView {
            if let nextRace = appData.nextRace {
                ForEach(nextRace.futureSessions, id: \.shortName) { session in
                    Session(appData: appData, nextRace: nextRace, session: session, name: session.shortName, delta: DeltaValues(date: session.startDate))
                }
            } else {
                Text("No data available.")
            }
        }
        .tabViewStyle(.verticalPage)
         */
    }
}

#Preview {
    ContentView(notificationController: NotificationController())
}
