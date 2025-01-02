//
//  f1_countdown_iosApp.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI
import SwiftData

@main
struct f1_countdown_iosApp: App {
    @State private var notificationController: NotificationController = NotificationController()
    
    var body: some Scene {
        WindowGroup {
            ContentView(notificationController: notificationController)
                .modelContainer(for: [RaceData.self])
        }
    }
}
