//
//  AppLicense.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 1.2.2024.
//

import SwiftUI

struct AppLicense: View {
    @Environment(\.openURL) private var openURL;

    var body: some View {
        Button {
            if let url = URL(string: "https://github.com/lassewolpmann-org/f1-countdown-ios/blob/development/LICENSE.md") {
                openURL(url);
            }
        } label: {
            Label("App License", systemImage: "globe")
        }
    }
}

#Preview {
    AppLicense()
}
