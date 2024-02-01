//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

@main
struct f1_countdown_iosApp: App {
    @State var config: APIConfig?;
    @State var nextRaces: [RaceData]?;
    @State var delta: deltaValues?;
    
    @State var dataLoaded: Bool = false;
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (dataLoaded) {
                    ContentView(nextRaces: nextRaces ?? [RaceData()], config: config ?? APIConfig(), delta: delta ?? deltaValues(dateString: [RaceData()].first!.sessions.first!.value))
                } else {
                    VStack {
                        Text("Loading data...")
                        ProgressView()
                    }
                }
            }.task {
                do {
                    config = try await getAPIConfig();
                    
                    let date = Date();
                    let calendar = Calendar.current;
                    var year = calendar.component(.year, from:date);
                    
                    nextRaces = try await callAPI(year: year);
                    
                    if (nextRaces!.isEmpty) {
                        year += 1;
                        
                        if (config!.availableYears.contains(year)) {
                            nextRaces = try await callAPI(year: year);
                        } else {
                            nextRaces = [RaceData()];
                        }
                    }
                    
                    let nextRace = nextRaces!.first!;
                    let sessions = nextRace.sessions.sorted(by:{$0.value < $1.value}).filter { key, value in
                        let date = ISO8601DateFormatter().date(from: value);
                        
                        return date!.timeIntervalSinceNow > 0
                    };
                    
                    delta = deltaValues(dateString: sessions.first!.value);
                    dataLoaded = true;
                } catch {
                    print("Error calling API")
                }
            }
        }
    }
}
