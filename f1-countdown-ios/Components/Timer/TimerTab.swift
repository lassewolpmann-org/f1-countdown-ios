//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

enum SessionStatus: String {
    case finished, ongoing, upcoming
}

struct TimerTab: View {
    var appData: AppData
    var userDefaults: UserDefaultsController
    var notificationController: NotificationController
    
    @State private var notificationsEnabled: Bool = false

    private func checkForExistingNotifications() -> Bool {
        if let nextRace = appData.nextRace {
            let sessionDates = Set(nextRace.futureSessions.map { $0.value.startDate })
            let notificationDates = notificationController.currentNotificationDates
            let intersect = sessionDates.intersection(notificationDates)
                        
            if (intersect.count == 0) {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
    
    private func removeNotifications() async -> Bool {
        if let nextRace = appData.nextRace {
            let sessionDates = nextRace.futureSessions.map { $0.value.startDate }
            let offsets = userDefaults.selectedOffsetOptions
            let sessionDatesWithOffsets = sessionDates.flatMap { date in
                let dateWithOffsets = offsets.map { offset in
                    date.addingTimeInterval(TimeInterval(offset * -60))
                }
                
                let dateStrings = dateWithOffsets.map { ISO8601DateFormatter().string(from: $0) }
                
                return dateStrings
            }
            
            for sessionDatesWithOffset in sessionDatesWithOffsets {
                notificationController.removeNotification(identifier: sessionDatesWithOffset)
            }
            
            return false
        } else {
            return notificationsEnabled
        }
    }
    
    private func createNotifications() async -> Void {
        if let nextRace = appData.nextRace {
            let status = await notificationController.permissionStatus
            
            if (status == .authorized) {
                for session in nextRace.futureSessions {
                    for offset in userDefaults.selectedOffsetOptions {
                        let notificationDate = session.value.startDate.addingTimeInterval(TimeInterval(offset * -60))
                        guard notificationDate.timeIntervalSinceNow > 0 else { continue }
                        
                        notificationsEnabled = await notificationController.addNotification(sessionDate: session.value.startDate, sessionName: session.value.longName, series: appData.currentSeries, title: nextRace.title, offset: offset)
                    }
                }
            } else if (status == .notDetermined) {
                await notificationController.createNotificationPermission()
            } else {
                print("Not allowed")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                if let nextRace = appData.nextRace {
                    VStack(alignment: .center, spacing: 15) {
                        ForEach(nextRace.pastSessions, id: \.key) { session in
                            // Calculate to current date to instantly set delta to 0
                            let delta = DeltaValues(date: Date.now)
                            Session(appData: appData, userDefaults: userDefaults, notificationController: notificationController, nextRace: nextRace, session: session.value, status: .finished, delta: delta)
                        }
                        
                        ForEach(nextRace.ongoingSessions, id: \.key) { session in
                            let delta = DeltaValues(date: session.value.endDate)
                            Session(appData: appData, userDefaults: userDefaults, notificationController: notificationController, nextRace: nextRace, session: session.value, status: .ongoing, delta: delta)
                        }
                        
                        ForEach(nextRace.futureSessions, id: \.key) { session in
                            let delta = DeltaValues(date: session.value.startDate)
                            Session(appData: appData, userDefaults: userDefaults, notificationController: notificationController, nextRace: nextRace, session: session.value, status: .upcoming, delta: delta)
                        }
                    }
                    .padding(.horizontal, 10)
                    .navigationTitle(nextRace.title)
                } else {
                    Label {
                        Text("It seems like there is no data available to display here.")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .bold()
                    .symbolRenderingMode(.multicolor)
                    .navigationTitle("Timer")
                }
            }
            .background(FlagBackground(flag: appData.nextRace?.flag ?? ""))
            .toolbar {
                Button {
                    Task {
                        notificationsEnabled = checkForExistingNotifications()
                        
                        if (notificationsEnabled) {
                            notificationsEnabled = await removeNotifications()
                        } else {
                            await createNotifications()
                        }
                    }
                } label: {
                    notificationsEnabled
                    ? Image(systemName: "bell.slash")
                    : Image(systemName: "bell")
                }
                .symbolRenderingMode(notificationsEnabled ? .multicolor : .monochrome)
                .contentTransition(.symbolEffect(.replace))
            }
        }
        .onAppear {
            notificationsEnabled = checkForExistingNotifications()
        }
        .onChange(of: notificationController.currentNotificationDates, { _, _ in
            notificationsEnabled = checkForExistingNotifications()
        })
        .refreshable {
            do {
                try await appData.loadAPIData()
            } catch {
                print("\(error), while refreshing TimerTab")
            }
        }
    }
}

#Preview {
    TimerTab(appData: AppData(), userDefaults: UserDefaultsController(), notificationController: NotificationController())
}
