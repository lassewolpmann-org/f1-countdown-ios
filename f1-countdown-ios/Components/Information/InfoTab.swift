//
//  AppInformation.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import SwiftUI

struct InfoTab: View {
    @Environment(\.openURL) private var openURL;
    
    var body: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String;
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String;
        
        NavigationStack {
            List {
                Section {
                    Button {
                        if let url = URL(string: "https://github.com/sportstimes/f1/blob/main/LICENSE") {
                            openURL(url);
                        }
                    } label: {
                        Label("Data Source License", systemImage: "globe")
                    }
                } footer: {
                    Text("App version \(version ?? "undefined")-\(build ?? "undefined")")
                }
            }.navigationTitle("Information")
        }
    }
}

#Preview {
    InfoTab()
}
