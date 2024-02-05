//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    let nextRaces: [RaceData];
    let config: APIConfig;
    let delta: deltaValues;
    
    let networkAvailable: Bool;
    
    var body: some View {
        TabView {
            TimerTab(nextRace: nextRaces.first!, delta: delta, config: config)
            .tabItem {
                Label("Timer", systemImage: "stopwatch")
            }
            
            CalendarTab(nextRaces: nextRaces, config: config)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            SettingsTab(networkAvailable: networkAvailable)
            .badge(networkAvailable ? nil : "!")
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
    ContentView(nextRaces: [RaceData()], config: APIConfig(), delta: deltaValues(dateString: [RaceData()].first!.sessions.first!.value), networkAvailable: true)
}
