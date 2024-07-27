//
//  AppInformation.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import SwiftUI

struct SettingsTab: View {
    var appData: AppData
    var userDefaults: UserDefaultsController
    var notificationController: NotificationController
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SeriesPicker(appData: appData)
                } header: {
                    Text("Series")
                }
                
                Section {
                    NotificationTime(appData: appData, userDefaults: userDefaults, notificationController: notificationController)
                    RemoveNotificationsButton()
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Changing Time of Notification reschedules all existing ones.")
                }
                
                Section {
                    DataLicense()
                    AppLicense()
                    WeatherLicense()
                    TrademarkNotice()
                } header: {
                    Text("Legal")
                } footer: {
                    SettingsFooter()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsTab(appData: AppData(), userDefaults: UserDefaultsController(), notificationController: NotificationController())
}
