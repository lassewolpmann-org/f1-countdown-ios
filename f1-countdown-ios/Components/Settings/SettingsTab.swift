//
//  AppInformation.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import SwiftUI

struct SettingsTab: View {
    @Environment(AppData.self) private var appData;
    @State private var reloadingData: Bool = false;

    var body: some View {
        NavigationStack {
            List {
                Section {
                    SeriesPicker(reloadingData: $reloadingData)
                        .environment(appData)
                } header: {
                    Text("Series")
                }
                
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
        .disabled(reloadingData)
        .overlay {
            if (reloadingData) {
                VStack {
                    ProgressView()
                    Text("Reloading data...")
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.background)
                )
            }
        }
    }
}

#Preview {
    SettingsTab()
        .environment(AppData(series: "f1"))
}
