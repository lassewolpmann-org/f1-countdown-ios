//
//  AppData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 6.2.2024.
//

import Foundation
import SwiftData
import CoreLocation

let availableSeries: [String] = ["f1", "f2", "f3", "f1-academy"]
let flags: [String: String] = [
    "bahrain-grand-prix": "🇧🇭",
    "bahrain": "🇧🇭",
    "saudi-arabia-grand-prix": "🇸🇦",
    "saudi-arabia": "🇸🇦",
    "jeddah": "🇸🇦",
    "australian-grand-prix": "🇦🇺",
    "melbourne": "🇦🇺",
    "japanese-grand-prix": "🇯🇵",
    "chinese": "🇨🇳",
    "chinese-grand-prix": "🇨🇳",
    "miami": "🇺🇸",
    "miami-grand-prix": "🇺🇸",
    "emilia-romagna-grand-prix": "🇮🇹",
    "emilia-romagna": "🇮🇹",
    "monaco-grand-prix": "🇲🇨",
    "monaco": "🇲🇨",
    "canadian": "🇨🇦",
    "canadian-grand-prix": "🇨🇦",
    "spanish-grand-prix": "🇪🇸",
    "spanish": "🇪🇸",
    "austrian-grand-prix": "🇦🇹",
    "austrian": "🇦🇹",
    "british-grand-prix": "🇬🇧",
    "british": "🇬🇧",
    "hungarian-grand-prix": "🇭🇺",
    "hungarian": "🇭🇺",
    "belgian-grand-prix": "🇧🇪",
    "belgian": "🇧🇪",
    "dutch-grand-prix": "🇳🇱",
    "zandvoort": "🇳🇱",
    "italian-grand-prix": "🇮🇹",
    "italian": "🇮🇹",
    "azerbaijan-grand-prix": "🇦🇿",
    "azerbaijan": "🇦🇿",
    "singapore-grand-prix": "🇸🇬",
    "singapore": "🇸🇬",
    "us-grand-prix": "🇺🇸",
    "mexico-grand-prix": "🇲🇽",
    "mexican-grand-prix": "🇲🇽",
    "brazilian-grand-prix": "🇧🇷",
    "las-vegas": "🇺🇸",
    "las-vegas-grand-prix": "🇺🇸",
    "qatar-grand-prix": "🇶🇦",
    "qatar": "🇶🇦",
    "abu-dhabi-grand-prix": "🇦🇪",
    "abu-dhabi": "🇦🇪"
]

enum AppDataError: Error {
    case fetchError(String)
    case URLError(String)
}

class RaceData {
    var series: String
    var season: Int
    var race: Season.Race
    var tbc: Bool = false
    
    var startDate: Date { self.race.sessions.first?.startDate ?? .now }
    var endDate: Date { self.race.sessions.last?.endDate ?? .now }
    
    init(series: String, season: Int, race: Season.Race, tbc: Bool) {
        self.series = series
        self.season = season
        self.race = race
        self.tbc = tbc
    }
}
