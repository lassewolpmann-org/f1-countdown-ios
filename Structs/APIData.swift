//
//  APIData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import Foundation

struct APIData: Decodable {
    let races: [RaceData]
}

struct RaceData: Decodable, Identifiable, Hashable {
    var name: String = "undefined"
    var location: String = "undefined place"
    var latitude: Double = 53.5
    var longitude: Double = 9.5
    var round: Int = 0
    var slug: String = "undefined-grand-prix"
    var localeKey: String = "undefined-grand-prix"
    var tbc: Bool?
    var sessions: [String: String] = ["fp1": "2024-01-01T00:00:00Z", "sprintQualifying": "2024-01-02T00:00:00Z", "gp": "2024-01-03T00:00:00Z"]
    
    var id: String {
        name
    }
}
