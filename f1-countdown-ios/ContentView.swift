//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppData.self) private var appData;
    
    var body: some View {
        TabView {
            TimerTab()
                .environment(appData)
            .tabItem {
                Label("Timer", systemImage: "stopwatch")
            }
            
            CalendarTab()
                .environment(appData)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            SettingsTab()
                .environment(appData)
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AppData(series: "f1"))
}
