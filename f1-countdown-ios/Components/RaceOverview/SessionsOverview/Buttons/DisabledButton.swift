//
//  DisabledButton.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct DisabledButton: View {
    var body: some View {
        Button {
            print("Do nothing, button is disabled")
        } label: {
            Label("Create Alert", systemImage: "bell")
        }
        .buttonStyle(.bordered)
        .labelStyle(.iconOnly)
        .disabled(true)
    }
}

#Preview {
    DisabledButton()
}
