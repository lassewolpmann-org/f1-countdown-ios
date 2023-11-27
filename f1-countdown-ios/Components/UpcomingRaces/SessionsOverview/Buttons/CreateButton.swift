//
//  CreateButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct CreateButton: View {
    @Binding var notificationEnabled: Bool;
    
    var sessionName: String;
    var sessionDate: String;
    var raceName: String;
    
    var body: some View {
        Button {
            createNotification(sessionDate: sessionDate, raceName: raceName, sessionName: sessionName);
            notificationEnabled = true;
        } label: {
                Label("Create Alert", systemImage: "bell")
        }
        .buttonStyle(.bordered)
        .labelStyle(.iconOnly)
    }
}

#Preview {
    CreateButton(notificationEnabled: .constant(false), sessionName: "fp1", sessionDate: "1970-01-01T00:00:00Z", raceName: "undefined")
}
