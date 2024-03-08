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
            Task {
                await rescheduleNotifications(time: selectionOption);
            }
        }
        .sensoryFeedback(.selection, trigger: selectionOption)
    }
}

#Preview {
    NotificationTime()
}
