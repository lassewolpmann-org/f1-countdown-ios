//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    var appData: AppData
    var userDefaults: UserDefaultsController
    
    var body: some View {
        TabView {
            TimerTab(appData: appData, userDefaults: userDefaults)
            .tabItem {
                Label("Timer", systemImage: "stopwatch")
            }
            
            CalendarTab(appData: appData)
            .tabItem {
                Label("Upcoming", systemImage: "calendar")
            }
            
            SettingsTab(appData: appData, userDefaults: userDefaults)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .task {
            await removeInvalidNotifications(appData: appData)
        }
    }
}

#Preview {
    ContentView(appData: AppData(), userDefaults: UserDefaultsController())
}
