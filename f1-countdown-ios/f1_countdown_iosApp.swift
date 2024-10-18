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
    @State private var colorSchemeController: ColorSchemeController = ColorSchemeController()
    
    // MARK: Main Entry
    var body: some Scene {
        WindowGroup {
            if (appData.dataLoaded) {
                ContentView(appData: appData, notificationController: notificationController, colorSchemeController: colorSchemeController)
                    .preferredColorScheme(getColorScheme())
            } else {
                ProgressView {
                    Text("Loading data...")
                }
            }
        }
    }
    
    func getColorScheme() -> ColorScheme? {
        switch colorSchemeController.selectedOption {
        case .dark:
            return .dark
        case .light:
            return .light
        case .system:
            return nil
        }
    }
}
