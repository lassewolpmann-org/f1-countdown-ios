//
//  WeatherLicense.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 16.4.2024.
//

import SwiftUI

struct WeatherLicense: View {
    @Environment(\.openURL) private var openURL;

    var body: some View {
        Button {
            if let url = URL(string: "https://weatherkit.apple.com/legal-attribution.html") {
                openURL(url);
            }
        } label: {
            Label("WeatherKit License", systemImage: "apple.logo")
        }
    }
}

#Preview {
    WeatherLicense()
}
