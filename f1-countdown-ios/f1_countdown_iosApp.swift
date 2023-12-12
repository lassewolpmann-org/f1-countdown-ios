//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

@main
struct f1_countdown_iosApp: App {
    @State var config: APIConfig = APIConfig();
    @State var nextRaces: [RaceData] = [RaceData]();
    
    @State var dataLoaded: Bool = false;
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (dataLoaded) {
                    ContentView(nextRaces: nextRaces, config: config)
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
                    
                    if (nextRaces.isEmpty) {
                        year += 1;
                        
                        if (config.availableYears.contains(year)) {
                            nextRaces = try await callAPI(year: year);
                        } else {
                            nextRaces = [RaceData()];
                        }
                    }
                    
                    dataLoaded = true;
                } catch {
                    print("Error calling API")
                }
            }
        }
    }
}
