//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

@main
struct f1_countdown_iosApp: App {
    @State private var appData: AppData = AppData(series: "f1");
    @State private var dataLoaded: Bool = false;
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (dataLoaded) {
                    ContentView()
                        .environment(appData)
                } else {
                    VStack {
                        Text("Loading data...")
                        ProgressView()
                    }
                }
            }.task {
                do {
                    appData.races = try await appData.getAllRaces()
                    dataLoaded = true;
                } catch {
                    print("\(error), while loading initial data")
                }
            }
        }
    }
}
