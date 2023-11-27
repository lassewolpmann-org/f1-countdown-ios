//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

@main
struct f1_countdown_iosApp: App {
    @State var nextRaces: [RaceData] = [RaceData]();
    @State var flags: [String: String] = [:]
    
    @State var dataLoaded: Bool = false;
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (dataLoaded) {
                    ContentView(nextRaces: nextRaces, flags: flags)
                } else {
                    VStack {
                        Text("Loading data...")
                        ProgressView()
                    }
                }
            }.task {
                do {
                    let config = try await getAPIConfig();
                    
                    let date = Date();
                    let calendar = Calendar.current;
                    var year = calendar.component(.year, from:date);
                    
                    nextRaces = try await callAPI(year: year);
                    
                    if (nextRaces.isEmpty) {
                        year += 1;
                        
                        if (config.availableYears.contains(year)) {
                            nextRaces = try await callAPI(year: year);
                        } else {
                            nextRaces = [RaceData()];
                        }
                    }
                    
                    for race in nextRaces {
                        flags[race.localeKey] = await getCountryFlag(latitude: race.latitude, longitude: race.longitude)
                    }
                    
                    dataLoaded = true;
                } catch {
                    print("Error calling API")
                }
            }
        }
    }
}
