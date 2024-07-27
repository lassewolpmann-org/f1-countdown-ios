//
//  NotificationTime.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 26.2.2024.
//

import SwiftUI

struct NotificationTime: View {
    @Bindable var appData: AppData
    @State private var showAlert = false
    var userDefaults: UserDefaultsController
    
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
                        userDefaults.toggleOffsetValue(offset: option)
                        
                        if (userDefaults.message.success == false) {
                            showAlert.toggle()
                        }
                    } label: {
                        userDefaults.selectedOffsetOptions.contains(option)
                        ? Image(systemName: "checkmark.circle")
                        : Image(systemName: "circle")
                    }
                    .foregroundStyle(
                        optionDisabled(option: option)
                        ? .secondary
                        : .primary
                    )
                    .foregroundStyle(
                        userDefaults.selectedOffsetOptions.contains(option)
                        ? .green
                        : .red
                    )
                    .animation(.easeInOut(duration: 0.2), value: userDefaults.selectedOffsetOptions.contains(option))
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
        .onChange(of: userDefaults.selectedOffsetOptions, { oldOffsets, newOffsets in
            Task {
                for offset in newOffsets {
                    await rescheduleNotifications(time: offset)
                }
            }
        })
        .alert("Notification Error", isPresented: $showAlert, actions: {
            Button("OK") {
                showAlert.toggle()
            }
        }, message: {
            Text(userDefaults.message.message)
        })
        .sensoryFeedback(.selection, trigger: userDefaults.selectedOffsetOptions)
    }
    
    func optionDisabled(option: Int) -> Bool {
        if (userDefaults.selectedOffsetOptions.contains(option) && userDefaults.selectedOffsetOptions.count == 1) {
            return true
        } else {
            return false
        }
    }
}

#Preview {
    NotificationTime(appData: AppData(), userDefaults: UserDefaultsController())
}
