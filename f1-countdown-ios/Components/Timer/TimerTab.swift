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
    
    @State var icon: Image?

    private func checkForExistingNotifications() async -> Bool {
        if let nextRace = appData.nextRace {
            let sessionDates = nextRace.futureSessions.map { $0.value.startDate }
            if let notificationsDates = await notificationController.currentNotifications.map({ $0.content.userInfo["sessionDate"] }) as? Array<Date> {
                let set1: Set<Date> = Set(sessionDates)
                let set2: Set<Date> = Set(notificationsDates)
                
                let intersect = set1.intersection(set2)
                if (intersect.count == 0) {
                    return false
                } else {
                    return true
                }
            }
                        
            return false
        } else {
            return false
        }
    }
    
    private func removeNotifications() async -> Void {
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
            
            notificationController.center.removePendingNotificationRequests(withIdentifiers: sessionDatesWithOffsets)
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
                        if (await checkForExistingNotifications()) {
                            await removeNotifications()
                            
                            // TODO: UI ISN'T UPDATED AFTER REMOVING NOTIFICATIONS
                        } else {
                            // TODO: ADD NOTIFICATIONS
                        }
                    }
                } label: {
                    icon
                }
                .task {
                    icon = await checkForExistingNotifications()
                    ? Image(systemName: "bell.slash")
                    : Image(systemName: "bell")
                }
            }
        }
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
