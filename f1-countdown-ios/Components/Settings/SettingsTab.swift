//
//  AppInformation.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import SwiftUI

struct SettingsTab: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NotificationTime()
                    RemoveNotificationsButton()
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Changing Time of Notification reschedules all existing ones.")
                }
                
                Section {
                    DataLicense()
                    AppLicense()
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
    SettingsTab()
}
