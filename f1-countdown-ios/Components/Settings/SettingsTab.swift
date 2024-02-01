//
//  AppInformation.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import SwiftUI

struct SettingsTab: View {
    let networkAvailable: Bool;
    
    var body: some View {
        NavigationStack {
            List {
                if (!networkAvailable) {
                    Section {
                        Text("No Network connection available. Data may not be up-to-date.")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    RemoveNotificationsButton()
                } header: {
                    Text("Notifications")
                }
                
                Section {
                    DataLicense()
                    AppLicense()
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
    SettingsTab(networkAvailable: false)
}
