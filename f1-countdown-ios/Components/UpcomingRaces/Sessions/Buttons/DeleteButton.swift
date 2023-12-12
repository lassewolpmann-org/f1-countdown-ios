//
//  DeleteButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct DeleteButton: View {
    @Binding var notificationEnabled: Bool;
    var sessionDate: Date;
    
    var body: some View {
        Button(role: .destructive) {
            deleteNotification(sessionDate: sessionDate)
            notificationEnabled = false;
        } label: {
            Label("Delete Alert", systemImage: "bell.slash")
        }
        .buttonStyle(.bordered)
        .labelStyle(.iconOnly)
    }
}

#Preview {
    DeleteButton(notificationEnabled: .constant(true), sessionDate: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!)
}
