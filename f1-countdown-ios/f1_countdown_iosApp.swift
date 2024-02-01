//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI
import Network

@main
struct f1_countdown_iosApp: App {
    @State var config: APIConfig?;
    @State var nextRaces: [RaceData]?;
    @State var delta: deltaValues?;
    
    @State private var dataLoaded: Bool = false;
    @State private var networkAvailable: Bool = false;
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (networkAvailable) {
                    if (dataLoaded) {
                        ContentView(nextRaces: nextRaces ?? [RaceData()], config: config ?? APIConfig(), delta: delta ?? deltaValues(dateString: [RaceData()].first!.sessions.first!.value))
                    } else {
                        VStack {
                            Text("Loading data...")
                            ProgressView()
                        }
                    }
                } else {
                    HStack {
                        Image(systemName: "network.slash")
                        Text("No network connection, cannot load data.")
                    }
                }
            }.task {
                // Start monitoring network status
                let monitor = NWPathMonitor()
                monitor.pathUpdateHandler = { path in
                    if (path.status == .satisfied) {
                        networkAvailable = true;
                        
                        // Load data once network is established
                        Task {
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
                    } else {
                        dataLoaded = false;
                        networkAvailable = false;
                    }
                };
                
                let queue = DispatchQueue(label: "NetworkMonitor")
                monitor.start(queue: queue)
            }
        }
    }
}
