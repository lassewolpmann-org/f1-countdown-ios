//
//  SampleData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 31.12.2024.
//


import Foundation
import SwiftUI
import SwiftData

let rawSampleRaces: [RawAPIData.Races.Race] = [
    RawAPIData.Races.Race(name: "Australian", location: "Melbourne", slug: "australian-grand-prix", sessions: [
        "fp1": ISO8601DateFormatter().string(from: .now.addingTimeInterval(10)),
        "fp2": ISO8601DateFormatter().string(from: .now.addingTimeInterval(20)),
        "fp3": ISO8601DateFormatter().string(from: .now.addingTimeInterval(30)),
        "qualifying": ISO8601DateFormatter().string(from: .now.addingTimeInterval(40)),
        "gp": ISO8601DateFormatter().string(from: .now.addingTimeInterval(50))
    ]),
    RawAPIData.Races.Race(name: "Chinese", location: "Shanghai", slug: "chinese-grand-prix", sessions: [
        "fp1": "2025-03-21T03:30:00Z",
        "sprintQualifying": "2025-03-21T07:30:00Z",
        "sprint": "2025-03-22T03:00:00Z",
        "qualifying": "2025-03-22T07:00:00Z",
        "gp": "2025-03-23T07:00:00Z"
    ]),
    RawAPIData.Races.Race(name: "Japanese", location: "Suzuka", slug: "japanese-grand-prix", sessions: [
        "fp1": "2025-04-04T02:30:00Z",
        "fp2": "2025-04-04T06:00:00Z",
        "fp3": "2025-04-05T02:30:00Z",
        "qualifying": "2025-04-05T06:00:00Z",
        "gp": "2025-04-06T05:00:00Z"
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
        RaceData(series: "f1", season: 2025, race: parseSampleRace(rawRace: race))
    }
}

struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: RaceData.self, configurations: config)
        
        for race in sampleRaces {
            container.mainContext.insert(race)
        }
        
        try container.mainContext.save()
        
        return container
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
