//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

@main
struct f1_countdown_iosApp: App {
    @State private var appData: AppData = AppData();
    
    var body: some Scene {
        WindowGroup {
            if (appData.dataLoaded) {
                ContentView(appData: appData)
            } else {
                ProgressView {
                    Text("Loading data...")
                }
                .task {
                    do {
                        appData.races = try await appData.getAllRaces()
                        appData.dataLoaded = true;
                    } catch {
                        print("\(error), while loading initial data")
                    }
                }
            }
        }
    }
}
