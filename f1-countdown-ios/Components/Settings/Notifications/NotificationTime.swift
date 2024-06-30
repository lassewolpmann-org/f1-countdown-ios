//
//  NotificationTime.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 26.2.2024.
//

import SwiftUI

struct NotificationTime: View {
    @Bindable var appData: AppData;
    @State private var showAlert = false;
    
    var body: some View {
        Picker("Send Notification", selection: $appData.selectedOffsetOption) {
            ForEach(appData.notificationOffsetOptions, id: \.self) { option in
                if (option == 0) {
                    Text("At Start of Session").tag(option)
                } else {
                    Text("\(option.description) Minutes before").tag(option)
                }
            }
        }
        .onChange(of: appData.selectedOffsetOption) {
            if let nextSession = appData.nextRace?.futureSessions.first?.value {
                let offset = appData.selectedOffsetOption
                let dateWithInterval = nextSession.startDate.addingTimeInterval(-Double(offset * 60))
                
                Task {
                    if (Date() >= dateWithInterval) {
                        print("Can't reschedule")
                    } else {
                        await rescheduleNotifications(time: offset)
                    }
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
        .sensoryFeedback(.selection, trigger: appData.selectedOffsetOption)
    }
}

#Preview {
    NotificationTime(appData: AppData())
}
