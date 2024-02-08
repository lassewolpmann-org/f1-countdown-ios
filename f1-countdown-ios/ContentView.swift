//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    let appData: AppData;
    let dataConfig: DataConfig;
    
    
    var body: some View {
        TabView {
            TimerTab(appData: appData, dataConfig: dataConfig)
            .tabItem {
                Label("Timer", systemImage: "stopwatch")
            }
            
            CalendarTab(nextRaces: appData.nextRaces, config: dataConfig)
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
    ContentView(appData: AppData(), dataConfig: DataConfig())
}
