//
//  ContentView.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct ContentView: View {
    var appData: AppData
    var notificationController: NotificationController
    
    var body: some View {
        TabView {
            if let nextRace = appData.nextRace {
                ForEach(nextRace.futureSessions, id: \.key) { session in
                    Session(appData: appData, nextRace: nextRace, session: session.value, name: session.value.shortName, delta: DeltaValues(date: session.value.startDate))
                }
            } else {
                Text("No data available.")
            }
        }
        .tabViewStyle(.verticalPage)
    }
}

#Preview {
    ContentView(appData: AppData(), notificationController: NotificationController())
}
