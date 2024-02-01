//
//  AppInformation.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import SwiftUI

struct SettingsTab: View {
    @Environment(\.openURL) private var openURL;
    
    var body: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String;
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String;
        
        NavigationStack {
            List {
                Section {
                    Button(role: .destructive) {
                        let center = UNUserNotificationCenter.current();
                        center.removeAllPendingNotificationRequests();
                        center.removeAllDeliveredNotifications();
                        print("Removed all Notifications")
                    } label: {
                        Label("Remove all Notifications", systemImage: "bell.slash")
                    }
                } header: {
                    Text("Notifications")
                }
                
                Section {
                    Button {
                        if let url = URL(string: "https://github.com/sportstimes/f1/blob/main/LICENSE") {
                            openURL(url);
                        }
                    } label: {
                        Label("Data Source License", systemImage: "globe")
                    }
                    
                    Button {
                        if let url = URL(string: "https://github.com/lassewolpmann-org/f1-countdown-ios/blob/development/LICENSE.md") {
                            openURL(url);
                        }
                    } label: {
                        Label("App License", systemImage: "globe")
                    }
                } header: {
                    Text("Legal")
                } footer: {
                    Text("App version \(version ?? "undefined")-\(build ?? "undefined")")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsTab()
}
