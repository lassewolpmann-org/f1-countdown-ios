//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    var appData: AppData
    var notificationController: NotificationController
    var colorSchemeController: ColorSchemeController
    
    var body: some View {
        TabView {
            TimerTab(appData: appData, notificationController: notificationController)
            .tabItem {
                Label("Timer", systemImage: "stopwatch")
            }
            
            CalendarTab(appData: appData)
            .tabItem {
                Label("Upcoming", systemImage: "calendar")
            }
            
            SettingsTab(appData: appData, notificationController: notificationController, colorSchemeController: colorSchemeController)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    ContentView(appData: AppData(), notificationController: NotificationController(), colorSchemeController: ColorSchemeController())
}
