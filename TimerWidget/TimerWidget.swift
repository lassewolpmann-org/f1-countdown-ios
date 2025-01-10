//
//  TimerWidget.swift
//  TimerWidget
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import WidgetKit
import SwiftUI

enum TimerWidgetError: Error {
    case nextUpdateError(String)
}

struct TimerEntry: TimelineEntry {
    let date: Date
    let race: Season.Race?
}

struct TimerWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily;
    
    let entry: TimerEntry;

    @ViewBuilder
    var body: some View {
        if let race = entry.race {
            switch family {
            /*
            case .accessoryCircular:
                print("circular")
            case .accessoryRectangular:
                print("rect")
            case .accessoryInline:
                print("inline")
            case .systemSmall:
                print("small")
             */
            case .systemLarge:
                Large(race: race)
            case .systemMedium:
                Medium(race: race)
            default:
                Label {
                    Text("Formula Countdown Widget is not available in this size.")
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                .containerBackground(for: .widget) {
                    Color(.systemBackground)
                }
            }
        } else {
            Label {
                Text("It seems like there is no data available to display here.")
            } icon: {
                Image(systemName: "exclamationmark.triangle.fill")
            }
            .containerBackground(for: .widget) {
                Color(.systemBackground)
            }
        }
    }
}

struct TimerWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimerEntry {
        let race = sampleRaces.first?.race
        let updateDate = race?.sessions.last?.endDate ?? Date()
        
        return TimerEntry(date: updateDate, race: race)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> Void) {
        Task {
            completion(try await createEntryData())
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> Void) {
        Task {
            let entry = try await createEntryData()
            let timeline = Timeline(entries: [entry], policy: .atEnd);
            
            completion(timeline)
        }
    }
    
    func createEntryData() async throws -> TimerEntry {
        let series = "f1"
        let year = Calendar(identifier: .gregorian).component(.year, from: Date())
        let baseURL = "https://raw.githubusercontent.com/sportstimes/f1/main/_db/\(series)"
        
        guard let configURL = URL(string: "\(baseURL)/config.json") else { throw AppDataError.URLError("Could not create Config URL string") }
        let (configData, _) = try await URLSession.shared.data(from: configURL)
        let config = try JSONDecoder().decode(RawAPIData.Config.self, from: configData)
        
        guard let racesURL = URL(string: "\(baseURL)/\(year).json") else { throw AppDataError.URLError("Could not create Season URL string") }

        let (racesData, _) = try await URLSession.shared.data(from: racesURL)
        let rawRaces = try JSONDecoder().decode(RawAPIData.Races.self, from: racesData).races
        let allRaces = rawRaces.map { newRace in
            return parseRace(rawRace: newRace, sessionLengths: config.sessionLengths)
        }
        
        let race = allRaces.first { race in
            guard let lastSessionEndDate = race.sessions.last?.endDate else { return false }
            return lastSessionEndDate > Date()
        }
        
        var allDates: [Date] = []
        
        race?.sessions.forEach { session in
            allDates.append(session.startDate)
            allDates.append(session.endDate)
        }
        
        let updateDate = allDates.first { $0 > Date() } ?? Date()
        print(updateDate)
        
        return TimerEntry(date: updateDate, race: race)
    }
    
    func parseRace(rawRace: RawAPIData.Races.Race, sessionLengths: [String: Int]) -> Season.Race {
        let sessions: [Season.Race.Session] = rawRace.sessions.compactMap { rawSession in
            let start = rawSession.value
            guard let startDate = ISO8601DateFormatter().date(from: start) else { return nil }
            guard let sessionLength = sessionLengths[rawSession.key] else { return nil }
            let endDate = startDate.addingTimeInterval(TimeInterval(sessionLength * 60))
            
            return Season.Race.Session(rawName: rawSession.key, startDate: startDate, endDate: endDate)
        }.sorted { $0.startDate < $1.startDate }
        
        return Season.Race(name: rawRace.name, location: rawRace.location, sessions: sessions, slug: rawRace.slug)
    }
}

struct TimerWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.lassewolpmann.f1-countdown-ios.TimerWidget", provider: TimerWidgetProvider()) { entry in
            TimerWidgetView(entry: entry)
                .modelContainer(for: [RaceData.self])
        }
        .configurationDisplayName("Timer")
        .description("Timer Widget to next F1 Grand Prix")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(date: Date(), race: sampleRaces.first?.race)
}
