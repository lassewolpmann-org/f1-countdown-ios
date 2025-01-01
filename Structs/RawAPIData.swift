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
        var sessions: [String]
        var sessionLengths: [String: Int]
    }
    
    struct Races: Codable {
        struct Race: Codable {
            var name: String
            var location: String
            var latitude: Double
            var longitude: Double
            var slug: String
            var sessions: [String: String]
        }
        
        var races: [RawAPIData.Races.Race]
    }
}
