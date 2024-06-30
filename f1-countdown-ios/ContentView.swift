//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    var appData: AppData;
    
    var body: some View {
        TabView {
            TimerTab(appData: appData)
            .tabItem {
                Label("Timer", systemImage: "stopwatch")
            }
            
            CalendarTab(appData: appData)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            SettingsTab(appData: appData)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }.task {
            await removeInvalidNotifications(appData: appData)
        }
    }
}

#Preview {
    ContentView(appData: AppData())
}
