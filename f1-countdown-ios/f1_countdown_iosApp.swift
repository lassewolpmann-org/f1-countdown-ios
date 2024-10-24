//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

@main
struct f1_countdown_iosApp: App {
    @State private var appData: AppData = AppData()
    @State private var notificationController: NotificationController = NotificationController()
    
    // MARK: Main Entry
    var body: some Scene {
        WindowGroup {
            if (appData.dataLoaded) {
                ContentView(appData: appData, notificationController: notificationController)
            } else {
                ProgressView {
                    Text("Loading data...")
                }
                .task {
                    do {
                        try await appData.loadAPIData()
                        
                        if (!appData.seriesData.isEmpty && !appData.sessionLengths.isEmpty) {
                            appData.dataLoaded = true
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
