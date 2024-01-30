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
    
    @State var selectedSession: String = "gp";
    
    var body: some View {
        TabView {
            TimerTab(nextRace: nextRaces.first!)
            .tabItem {
                Label("Timer", systemImage: "stopwatch")
            }
            
            CalendarTab(nextRaces: nextRaces, config: config)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            
            InfoTab()
            .tabItem {
                Label("Information", systemImage: "info.circle")
            }
        }
    }
}

#Preview {
    ContentView(nextRaces: [RaceData()], config: APIConfig())
}
