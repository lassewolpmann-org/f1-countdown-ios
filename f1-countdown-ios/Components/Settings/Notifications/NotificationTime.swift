//
//  NotificationTime.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 26.2.2024.
//

import SwiftUI

struct NotificationTime: View {
    var appData: AppData;
    let availableOptions: [Int] = [0, 5, 10, 15, 30, 60];
    @State private var selectionOption: Int = 0;
    @State private var showAlert = false;
    
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
            let nextSession = appData.nextRace?.futureSessions.first!;
            let date = ISO8601DateFormatter().date(from: nextSession?.value ?? "")!;
            let dateWithInterval = date.addingTimeInterval(-Double(selectionOption * 60))
            
            Task {
                if (Date() >= dateWithInterval) {
                    print("Can't reschedule")
                } else {
                    await rescheduleNotifications(time: selectionOption);
                }
            }
        }
        .alert("Notification Error", isPresented: $showAlert, actions: {
            Button("OK") {
                showAlert.toggle()
            }
        }, message: {
            Text("Invalid option. The next Session Date is sooner than the selected Notification Time offset.")
        })
        .sensoryFeedback(.selection, trigger: selectionOption)
    }
}

#Preview {
    NotificationTime(appData: AppData())
}
