//
//  AppInformation.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import SwiftUI

struct SettingsTab: View {
    @Binding var selectedSeries: String
    
    let allRaces: [String: [RaceData]]
    let notificationController: NotificationController
    
    var body: some View {
        NavigationStack {
            List {
                NotificationsView(allRaces: allRaces, notificationController: notificationController)
                LegalView()
            }
            .navigationTitle("Settings")
        }
    }
    
    struct NotificationsView: View {
        let allRaces: [String: [RaceData]]
        let notificationController: NotificationController

        var body: some View {
            Section {
                NotificationTimeView(allRaces: allRaces, notificationController: notificationController)
                RemoveNotificationsButtonView()
            } header: {
                Text("Notifications")
            } footer: {
                Text("Changing Time of Notification reschedules all existing ones.")
            }
        }
        
        struct NotificationTimeView: View {
            let allRaces: [String: [RaceData]]
            let notificationController: NotificationController
            
            var allRacesMapped: [RaceData] {
                return allRaces.flatMap { $0.value }
            }
            
            var body: some View {
                NavigationLink {
                    List(notificationController.notificationOffsetOptions, id: \.self) { option in
                        HStack {
                            if (option == 0) {
                                Text("At Start of Session").tag(option)
                            } else {
                                Text("\(option.description) Minutes before").tag(option)
                            }
                            
                            Spacer()
                            
                            Button {
                                notificationController.toggleOffsetValue(offset: option)
                            } label: {
                                notificationController.selectedOffsetOptions.contains(option)
                                ? Image(systemName: "checkmark.circle")
                                : Image(systemName: "circle")
                            }
                            .foregroundStyle(
                                optionDisabled(option: option)
                                ? .secondary
                                : .primary
                            )
                            .foregroundStyle(
                                notificationController.selectedOffsetOptions.contains(option)
                                ? .green
                                : .red
                            )
                            .animation(.easeInOut(duration: 0.2), value: notificationController.selectedOffsetOptions.contains(option))
                            .disabled(optionDisabled(option: option))
                        }
                        .foregroundStyle(
                            optionDisabled(option: option)
                            ? .secondary
                            : .primary
                        )
                    }
                    .navigationTitle("Notification Time")
                } label: {
                    Text("Choose Notification Time")
                }
                .onChange(of: notificationController.selectedOffsetOptions, { oldOffsets, newOffsets in
                    Task {
                        let currentNotifications = await notificationController.currentNotifications
                        let difference = newOffsets.difference(from: oldOffsets)

                        for diff in difference {
                            guard let currentDates = currentNotifications.map({ $0.content.userInfo["sessionDate"] }) as? [Date] else { continue }
                            let currentDatesSet = Set(currentDates)
                            
                            switch diff {
                            case let .remove(_, offset, _):
                                let datesToRemove = currentDatesSet.map { date in
                                    return date.addingTimeInterval(TimeInterval(offset * -60)).ISO8601Format()
                                }
                                
                                notificationController.center.removePendingNotificationRequests(withIdentifiers: datesToRemove)
                            case .insert:
                                for date in currentDatesSet {
                                    if (currentNotifications.first(where: { notification in
                                        notification.content.userInfo["sessionDate"] as? Date == date
                                    }) != nil) {
                                        guard let race = allRacesMapped.first(where: { race in
                                            let raceSessionDates = race.race.sessions.map { $0.startDate }
                                            return raceSessionDates.contains(date)
                                        }) else { continue }
                                        
                                        guard let session = race.race.sessions.first(where: { session in
                                            session.startDate == date
                                        }) else { continue }
                                                
                                        await notificationController.addSessionNotifications(race: race, session: session)
                                    }
                                }
                            }
                        }
                    }
                })
            }
            
            func optionDisabled(option: Int) -> Bool {
                if (notificationController.selectedOffsetOptions.contains(option) && notificationController.selectedOffsetOptions.count == 1) {
                    return true
                } else {
                    return false
                }
            }
        }
        
        struct RemoveNotificationsButtonView: View {
            @State private var showAlert: Bool = false;
            @State private var buttonState: Bool = false;
            
            var body: some View {
                Button {
                    buttonState.toggle();
                    let center = UNUserNotificationCenter.current();
                    center.removeAllPendingNotificationRequests();
                    center.removeAllDeliveredNotifications();
                    showAlert.toggle();
                } label: {
                    Label("Remove all Notifications", systemImage: "bell.slash")
                }
                .alert(
                    Text("Success"),
                    isPresented: $showAlert
                ) {
                    Button("OK") {
                        showAlert.toggle()
                    }
                } message: {
                    Text("Removed all Notifications")
                }
                .sensoryFeedback(.success, trigger: buttonState)
            }
        }
    }
    
    struct LegalView: View {
        @Environment(\.openURL) private var openURL

        var body: some View {
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
    }
}

#Preview {
    SettingsTab(selectedSeries: .constant("f1"), allRaces: ["f1" : sampleRaces], notificationController: NotificationController())
}
