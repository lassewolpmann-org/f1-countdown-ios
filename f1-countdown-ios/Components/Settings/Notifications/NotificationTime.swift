//
//  NotificationTime.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 26.2.2024.
//

import SwiftUI

struct NotificationTime: View {
    let availableOptions: [Int] = [0, 5, 10, 15, 30, 60];
    @State private var selectionOption: Int = 0;
    
    var body: some View {
        Picker("Send Notification", selection: $selectionOption) {
            ForEach(availableOptions, id: \.self) { option in
                if (option == 0) {
                    Text("At Start of Session").tag(option)
                } else {
                    Text("\(option.description) Minutes before").tag(option)
                }
            }
        }
        .onAppear {
            // Retrieve saved option
            selectionOption = UserDefaults.standard.integer(forKey: "Notification");
        }
        .onChange(of: selectionOption) {
            // Save option ot User Defaults
            UserDefaults.standard.set(selectionOption, forKey: "Notification")
            
            // Update all Notifications
            let center = UNUserNotificationCenter.current();
            center.getPendingNotificationRequests { notifications in
                for notification in notifications {
                    // Step 1: Get Current Identifier which is the Date in ISO8601 format
                    let notificationIdentifier = notification.identifier;
                    
                    // Step 2: Remove current Notification
                    center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier]);

                    // Step 3: Create new Date with added Minutes
                    let notificationDate = ISO8601DateFormatter().date(from: notificationIdentifier);
                    let newNotificationDate = notificationDate?.addingTimeInterval(TimeInterval(selectionOption * 60));
                    
                    let calendarDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: newNotificationDate!)
                    print(calendarDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: calendarDate, repeats: false);
                    
                    // Step 4: Create new Notification
                    let newNotification = UNNotificationRequest(identifier: notificationIdentifier, content: notification.content, trigger: trigger);
                    
                    Task {
                        do {
                            try await center.add(newNotification);
                            print("Notifcation created")
                        } catch {
                            print("Error while creating notification")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationTime()
}
