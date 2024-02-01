//
//  SettingsFooter.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 1.2.2024.
//

import SwiftUI

struct SettingsFooter: View {
    var body: some View {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String;
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String;
        
        Text("App version \(version ?? "undefined")-\(build ?? "undefined")")
    }
}

#Preview {
    SettingsFooter()
}
