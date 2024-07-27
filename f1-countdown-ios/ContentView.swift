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
    var notificationController: NotificationController
    
    var body: some View {
        TabView {
            TimerTab(appData: appData, userDefaults: userDefaults, notificationController: notificationController)
            .tabItem {
                Label("Timer", systemImage: "stopwatch")
            }
            
            CalendarTab(appData: appData)
            .tabItem {
                Label("Upcoming", systemImage: "calendar")
            }
            
            SettingsTab(appData: appData, userDefaults: userDefaults, notificationController: notificationController)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    ContentView(appData: AppData(), userDefaults: UserDefaultsController(), notificationController: NotificationController())
}
