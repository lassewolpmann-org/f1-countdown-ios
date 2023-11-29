//
//  APIConfig.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import Foundation

struct APIConfig: Decodable {
    var availableYears: [Int] = [2024]
    var sessions: [String] = ["undefined 1", "undefined 2"]
    var sessionLengths: [String: Int] = ["undefined 1": 60, "undefined 2": 30]
}
