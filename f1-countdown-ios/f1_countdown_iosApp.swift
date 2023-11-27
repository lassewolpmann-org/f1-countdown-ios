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
    @State var validData: Bool = false;
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (nextRaces.isEmpty) {
                    ProgressView()
                } else {
                    if (validData) {
                        ContentView(nextRaces: nextRaces)
                    } else {
                        Text("No data available.")
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
                            validData = true;
                        } else {
                            nextRaces = [RaceData()]
                            validData = false;
                        }
                    } else {
                        validData = true;
                    }
                } catch {
                    print("Error calling API")
                }
            }
        }
    }
}
