//
//  ContentView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    let allRaces: [String: [RaceData]]
    let notificationController: NotificationController

    @State var loadingData = true
    @State var selectedSeries: String = "f1"
    
    var seriesRaces: [RaceData] {
        return allRaces[selectedSeries] ?? []
    }
    
    var body: some View {
        TabView {
            Tab {
                TimerTabView(seriesRaces: seriesRaces, selectedSeries: $selectedSeries, notificationController: notificationController)
            } label: {
                Label("Timer", systemImage: "stopwatch")
            }
            
            Tab {
                UpcomingTabCalendarView(allRaces: allRaces, notificationController: notificationController)
            } label: {
                Label("Upcoming", systemImage: "calendar")
            }
            
            Tab {
                SettingsTab(selectedSeries: $selectedSeries, allRaces: allRaces, notificationController: notificationController)
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    ContentView(allRaces: ["f1": sampleRaces], notificationController: NotificationController())
}
