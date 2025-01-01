//
//  SampleData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 31.12.2024.
//


import Foundation
import SwiftUI
import SwiftData

var sampleSeriesData: [SeriesData] {
    let config = RawAPIData.Config(availableYears: [2024], sessions: ["fp1", "fp2", "fp3", "qualifying", "gp"], sessionLengths: [
        "fp1": 60,
        "fp2": 60,
        "fp3": 60,
        "qualifying": 60,
        "gp": 120
    ])
    
    return availableSeries.map { series in
        let firstRaceSessions = [
            SessionData(rawName: "fp1", startDate: Date.now.addingTimeInterval(10), endDate: Date.now.addingTimeInterval(20)),
            SessionData(rawName: "fp2", startDate: Date.now.addingTimeInterval(30), endDate: Date.now.addingTimeInterval(40)),
            SessionData(rawName: "fp3", startDate: Date.now.addingTimeInterval(50), endDate: Date.now.addingTimeInterval(60)),
            SessionData(rawName: "qualifying", startDate: Date.now.addingTimeInterval(70), endDate: Date.now.addingTimeInterval(80)),
            SessionData(rawName: "gp", startDate: Date.now.addingTimeInterval(90), endDate: Date.now.addingTimeInterval(100)),
        ]
        
        let firstRace = RaceData(name: "Test Race 1", location: "Test Location", latitude: 0.0, longitude: 0.0, sessions: firstRaceSessions, slug: "bahrain-grand-prix")
        
        let secondRaceSessions = [
            SessionData(rawName: "fp1", startDate: Date.now.addingTimeInterval(110), endDate: Date.now.addingTimeInterval(120)),
            SessionData(rawName: "fp2", startDate: Date.now.addingTimeInterval(130), endDate: Date.now.addingTimeInterval(140)),
            SessionData(rawName: "fp3", startDate: Date.now.addingTimeInterval(150), endDate: Date.now.addingTimeInterval(160)),
            SessionData(rawName: "qualifying", startDate: Date.now.addingTimeInterval(170), endDate: Date.now.addingTimeInterval(180)),
            SessionData(rawName: "gp", startDate: Date.now.addingTimeInterval(190), endDate: Date.now.addingTimeInterval(200)),
        ]
        
        let secondRace = RaceData(name: "Test Race 2", location: "Test Location", latitude: 0.0, longitude: 0.0, sessions: secondRaceSessions, slug: "saudi-arabia-grand-prix")
        
        let seasonData = SeasonData(year: 2025, races: [firstRace, secondRace])
        
        return SeriesData(series: series, seasons: [seasonData], config: config)
    }
}

var sampleRaceData: RaceData {
    RaceData(name: "Test Race 1", location: "Test Location", latitude: 0.0, longitude: 0.0, sessions: [sampleSessionData, sampleSessionData, sampleSessionData, sampleSessionData, sampleSessionData], slug: "bahrain-grand-prix")
}

var sampleSessionData: SessionData {
    SessionData(rawName: "fp1", startDate: Date.now.addingTimeInterval(10), endDate: Date.now.addingTimeInterval(20))
}

struct SampleData: PreviewModifier {
    static func makeSharedContext() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: SeriesData.self, configurations: config)
        
        for data in sampleSeriesData {
            container.mainContext.insert(data)
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
