//
//  NotificationTime.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 26.2.2024.
//

import SwiftUI
import SwiftData

struct NotificationTime: View {
    @Query var allRaces: [RaceData]
    var notificationController: NotificationController
    
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
                                guard let race = allRaces.first(where: { race in
                                    let raceSessionDates = race.race.sessions.map { $0.startDate }
                                    return raceSessionDates.contains(date)
                                }) else { continue }
                                
                                guard let session = race.race.sessions.first(where: { session in
                                    session.startDate == date
                                }) else { continue }
                                        
                                let _ = await notificationController.addSessionNotifications(race: race, session: session)
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

#Preview {
    NotificationTime(notificationController: NotificationController())
}
