//
//  DataConfig.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.2.2024.
//

import Foundation

struct DataConfig: Decodable {
    var availableYears = [2024];
    var sessions = ["undefined 1", "undefined 2"];
    var sessionLengths = ["undefined 1": 60, "undefined 2": 30];
    
    var config: DataConfig {
        get async throws {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://raw.githubusercontent.com/sportstimes/f1/main/_db/f1/config.json")!);
            return try JSONDecoder().decode(DataConfig.self, from: data)
        }
    }
}
