//
//  ColorSchemeController.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.10.2024.
//

import Foundation
import SwiftUICore

enum UserColorScheme: String {
    case dark = "dark"
    case light = "light"
    case system = "system"
}

@Observable class ColorSchemeController {
    let key: String = "ColorScheme"
    let userDefaults = UserDefaults.standard
    let options: [UserColorScheme] = [.dark, .light, .system]
    
    var selectedOption: UserColorScheme
    
    init() {
        selectedOption = UserColorScheme(rawValue: userDefaults.string(forKey: key) ?? "system") ?? .system
    }
    
    func updateSelectedScheme() -> Void {
        self.userDefaults.set(selectedOption.rawValue, forKey: key)
    }
}
