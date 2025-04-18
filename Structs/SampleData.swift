//
//  SampleData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 31.12.2024.
//


import Foundation

let rawSampleRaces: [RawAPIData.Races.Race] = [

    RawAPIData.Races.Race(name: "Chinese", location: "Shanghai", slug: "chinese-grand-prix", sessions: [
        "fp1": "2025-03-21T03:30:00Z",
        "sprintQualifying": "2025-03-21T07:30:00Z",
        "sprint": "2025-03-22T03:00:00Z",
        "qualifying": "2025-03-22T07:00:00Z",
        "gp": "2025-03-23T07:00:00Z"
    ]),
    RawAPIData.Races.Race(name: "Australian", location: "Melbourne", slug: "australian-grand-prix", sessions: [
        "fp1": ISO8601DateFormatter().string(from: .now.addingTimeInterval(10)),
        "fp2": ISO8601DateFormatter().string(from: .now.addingTimeInterval(20)),
        "fp3": ISO8601DateFormatter().string(from: .now.addingTimeInterval(30)),
        "qualifying": ISO8601DateFormatter().string(from: .now.addingTimeInterval(40)),
        "gp": ISO8601DateFormatter().string(from: .now.addingTimeInterval(50))
    ]),
    RawAPIData.Races.Race(name: "Japanese", location: "Suzuka", slug: "japanese-grand-prix", sessions: [
        "fp1": ISO8601DateFormatter().string(from: .now.addingTimeInterval(60 * 60 * 24 * 7)),
        "fp2": ISO8601DateFormatter().string(from: .now.addingTimeInterval(60 * 60 * 24 * 8)),
        "fp3": ISO8601DateFormatter().string(from: .now.addingTimeInterval(60 * 60 * 24 * 9)),
        "qualifying": ISO8601DateFormatter().string(from: .now.addingTimeInterval(60 * 60 * 24 * 10)),
        "gp": ISO8601DateFormatter().string(from: .now.addingTimeInterval(60 * 60 * 24 * 11))
    ])
]

var sampleRaces: [RaceData] {
    func parseSampleRace(rawRace: RawAPIData.Races.Race) -> Season.Race {
        let sessions: [Season.Race.Session] = rawRace.sessions.compactMap { rawSession in
            let start = rawSession.value
            guard let startDate = ISO8601DateFormatter().date(from: start) else { return nil }
            let endDate = startDate.addingTimeInterval(TimeInterval(2))
            
            return Season.Race.Session(rawName: rawSession.key, startDate: startDate, endDate: endDate)
        }.sorted { $0.startDate < $1.startDate }
        
        return Season.Race(name: rawRace.name, location: rawRace.location, sessions: sessions, slug: rawRace.slug)
    }
    
    return rawSampleRaces.map { race in
        RaceData(series: "f1", season: 2025, race: parseSampleRace(rawRace: race), tbc: false)
    }
}
