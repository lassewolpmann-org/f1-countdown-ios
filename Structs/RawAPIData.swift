//
//  RawAPIData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 1.1.2025.
//

import Foundation

struct RawAPIData: Codable {
    struct Config: Codable {
        var availableYears: [Int]
        
        var yearsToParse: [Int] {
            let currentYear = Calendar(identifier: .gregorian).component(.year, from: Date())
            return availableYears.filter { $0 >= currentYear }
        }
        
        var sessions: [String]
        var sessionLengths: [String: Int]
    }
    
    struct Races: Codable {
        struct Race: Codable {
            var name: String
            var location: String
            var slug: String
            var sessions: [String: String]
        }
        
        var races: [RawAPIData.Races.Race]
    }
}
