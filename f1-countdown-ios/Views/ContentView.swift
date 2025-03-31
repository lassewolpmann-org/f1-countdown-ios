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
                TimerTabView(seriesRaces: seriesRaces, selectedSeries: selectedSeries, notificationController: notificationController)
            } label: {
                Label("Timer", systemImage: "stopwatch")
            }
            
            Tab {
                UpcomingTabView(allRaces: allRaces, selectedSeries: selectedSeries, notificationController: notificationController)
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
    
    func rescheduleNotifications(diffCollection: CollectionDifference<Season.Race.Session>, race: RaceData, notificationSlugs: Set<String>, notificationSessionNames: Set<String>) async -> Void {
        WidgetCenter.shared.reloadAllTimelines()
        
        let raceSlug = race.race.slug
        
        guard notificationSlugs.contains(raceSlug) else { return }
        
        for diff in diffCollection {
            switch diff {
            case let .insert(_, session, _):
                guard notificationSessionNames.contains(session.longName) else { continue }
                
                let _ = await notificationController.addSessionNotifications(race: race, session: session)
            case let .remove(_, session, _):
                guard notificationSessionNames.contains(session.longName) else { continue }

                for offset in notificationController.selectedOffsetOptions {
                    let identifier = session.startDate.addingTimeInterval(TimeInterval(offset * -60)).ISO8601Format()
                    notificationController.center.removePendingNotificationRequests(withIdentifiers: [identifier])
                }
            }
        }
    }
}

#Preview {
    ContentView(allRaces: ["f1": sampleRaces], notificationController: NotificationController())
}
