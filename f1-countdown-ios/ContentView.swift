//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    @State var nextRace: RaceData;
    @State var nextRaces: [RaceData];
    @State var dataConfig: DataConfig;
    
    var body: some View {
        TabView {
            TimerTab(nextRace: nextRace, dataConfig: dataConfig)
            .tabItem {
                Label("Timer", systemImage: "stopwatch")
            }
            
            CalendarTab(nextRaces: nextRaces, config: dataConfig)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            SettingsTab()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .task {
            // Ask for permission to send Notifications
            await createNotificationPermission()
        }
    }
}

#Preview {
    ContentView(nextRace: RaceData(), nextRaces: [RaceData()], dataConfig: DataConfig())
}
