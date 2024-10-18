//
//  NotificationTime.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 26.2.2024.
//

import SwiftUI

struct NotificationTime: View {
    @Bindable var appData: AppData
    var notificationController: NotificationController
    
    var body: some View {
        NavigationLink {
            List(appData.notificationOffsetOptions, id: \.self) { option in
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
                let difference = newOffsets.difference(from: oldOffsets).first

                if let currentSessionDates = currentNotifications.map({ $0.content.userInfo["sessionDate"] }) as? [Date] {
                    let dateSet = Set(currentSessionDates)
                    
                    switch difference {
                    case let .remove(_, offset, _):
                        let dates = dateSet.map { date in
                            return date.addingTimeInterval(TimeInterval(offset * -60)).ISO8601Format()
                        }
                        
                        notificationController.center.removePendingNotificationRequests(withIdentifiers: dates)
                    case let .insert(_, offset, _):
                        for date in dateSet {
                            if let currentNotification = currentNotifications.first(where: { notification in
                                notification.content.userInfo["sessionDate"] as? Date == date
                            }) {
                                if let date = currentNotification.content.userInfo["sessionDate"] as? Date,
                                   let name = currentNotification.content.userInfo["sessionName"] as? String,
                                   let series = currentNotification.content.userInfo["series"] as? String {
                                    
                                    let _ = await notificationController.addNotification(sessionDate: date, sessionName: name, series: series, title: currentNotification.content.title, offset: offset)
                                }
                            }
                        }
                    case .none:
                        print("No difference")
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
    NotificationTime(appData: AppData(), notificationController: NotificationController())
}
