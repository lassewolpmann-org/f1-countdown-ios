//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

@main
struct f1_countdown_iosApp: App {
    @State var nextRace: RaceData = RaceData();
    @State var nextRaces: [RaceData] = [RaceData()];
    
    @State private var dataLoaded: Bool = false;
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (dataLoaded) {
                    ContentView(nextRace: nextRace, nextRaces: nextRaces)
                } else {
                    VStack {
                        Text("Loading data...")
                        ProgressView()
                    }
                }
            }.task {
                do {
                    nextRaces = try await AppData().nextRaces;
                    nextRace = try await AppData().nextRace;
                    
                    dataLoaded = true;
                } catch {
                    print("API Call failed")
                }
            }
        }
    }
}
