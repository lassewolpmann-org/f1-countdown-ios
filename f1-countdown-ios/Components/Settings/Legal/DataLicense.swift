//
//  DataLicense.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 1.2.2024.
//

import SwiftUI

struct DataLicense: View {
    @Environment(\.openURL) private var openURL;

    var body: some View {
        Button {
            if let url = URL(string: "https://github.com/sportstimes/f1/blob/main/LICENSE") {
                openURL(url);
            }
        } label: {
            Label("Data Source License", systemImage: "globe")
        }
    }
}

#Preview {
    DataLicense()
}
