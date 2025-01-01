//
//  AppInformation.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import SwiftUI

struct SettingsTab: View {
    @Environment(\.openURL) private var openURL;
    @Binding var selectedSeries: String
    
    let notificationController: NotificationController
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker(selection: $selectedSeries) {
                        ForEach(availableSeries, id:\.self) { series in
                            Text(series.uppercased())
                        }
                    } label: {
                        Text("Select Series")
                    }
                    .sensoryFeedback(.selection, trigger: selectedSeries)
                } header: {
                    Text("Series")
                }
                
                Section {
                    NotificationTime(notificationController: notificationController)
                    RemoveNotificationsButton()
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Changing Time of Notification reschedules all existing ones.")
                }
                
                Section {
                    // MARK: Data License
                    Button {
                        if let url = URL(string: "https://github.com/sportstimes/f1/blob/main/LICENSE") {
                            openURL(url);
                        }
                    } label: {
                        Label("Data Source License", systemImage: "globe")
                    }
                    
                    // MARK: App License
                    Button {
                        if let url = URL(string: "https://github.com/lassewolpmann-org/f1-countdown-ios/blob/development/LICENSE.md") {
                            openURL(url);
                        }
                    } label: {
                        Label("App License", systemImage: "globe")
                    }
                    
                    // MARK: WeatherKit License
                    Button {
                        if let url = URL(string: "https://weatherkit.apple.com/legal-attribution.html") {
                            openURL(url);
                        }
                    } label: {
                        Label("WeatherKit License", systemImage: "apple.logo")
                    }
                    
                    // MARK: Trademark Notice
                    VStack(alignment: .leading) {
                        Text("This app is unofficial and is not associated in any way with the Formula 1 companies.")
                        Text("")
                        Text("F1, FORMULA ONE, FORMULA 1, FIA FORMULA ONE WORLD CHAMPIONSHIP, GRAND PRIX and related marks are trade marks of Formula One Licensing B.V.")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                } header: {
                    Text("Legal")
                } footer: {
                    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String;
                    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String;
                    
                    Text("App version \(version ?? "undefined")-\(build ?? "undefined")")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsTab(selectedSeries: .constant("f1"), notificationController: NotificationController())
}
