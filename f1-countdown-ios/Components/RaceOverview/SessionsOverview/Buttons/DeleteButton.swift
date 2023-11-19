//
//  DeleteButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct DeleteButton: View {
    @Binding var notificationEnabled: Bool;
    var sessionDate: String;
    
    var body: some View {
        let notificationCenter = UNUserNotificationCenter.current();
        
        Button(role: ButtonRole.destructive) {
            notificationEnabled = false;
            
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [sessionDate])
        } label: {
            Label("Delete Alert", systemImage: "bell.slash")
        }
        .buttonStyle(.bordered)
        .labelStyle(.iconOnly)
    }
}

#Preview {
    DeleteButton(notificationEnabled: .constant(true), sessionDate: "1970-01-01T00:00:00Z")
}
