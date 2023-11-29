//
//  TimerWidget.swift
//  TimerWidget
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import WidgetKit
import SwiftUI

struct TimerEntry: TimelineEntry {
    let date: Date;
    let raceName: String;
    let sessions: [String: String];
    let flag: String;
    let sessionLengths: [String: Int];
}

struct TimerWidgetView: View {
    let entry: TimerEntry;

    @Environment(\.widgetFamily) var family: WidgetFamily;

    @ViewBuilder
    var body: some View {
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
            Large(entry: entry)
        case .systemMedium:
            Medium(entry: entry)
        default:
            Medium(entry: entry)
        }
    }
}

struct TimerTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimerEntry {
        let date = Date();
        let entry = TimerEntry(date: date, raceName: RaceData().name, sessions: RaceData().sessions, flag: "", sessionLengths: APIConfig().sessionLengths);
        
        return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> Void) {
        Task {
            let config = try await getAPIConfig();
            
            let date = Date();
            let calendar = Calendar.current;
            var year = calendar.component(.year, from:date);
            
            var nextRaces = try await callAPI(year: year);
            
            if (nextRaces.isEmpty) {
                year += 1;
                
                if (config.availableYears.contains(year)) {
                    nextRaces = try await callAPI(year: year);
                } else {
                    nextRaces = [RaceData()];
                }
            }
            
            let nextRace = nextRaces.first ?? RaceData();
            let flag = await getCountryFlag(latitude: nextRace.latitude, longitude: nextRace.longitude);
            let entry = TimerEntry(date: date, raceName: nextRace.name, sessions: nextRace.sessions, flag: flag, sessionLengths: config.sessionLengths);
            
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> Void) {
        Task {
            let config = try await getAPIConfig();
            
            let date = Date();
            let calendar = Calendar.current;
            var year = calendar.component(.year, from:date);
            
            var nextRaces = try await callAPI(year: year);
            
            if (nextRaces.isEmpty) {
                year += 1;
                
                if (config.availableYears.contains(year)) {
                    nextRaces = try await callAPI(year: year);
                } else {
                    nextRaces = [RaceData()];
                }
            }
            
            let nextRace = nextRaces.first ?? RaceData();
            let flag = await getCountryFlag(latitude: nextRace.latitude, longitude: nextRace.longitude);
            let entry = TimerEntry(date: date, raceName: nextRace.name, sessions: nextRace.sessions, flag: flag, sessionLengths: config.sessionLengths);
            let nextUpdateDate = getNextUpdateDate(race: nextRace);
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate));
            
            completion(timeline)
        }
    }
}

struct TimerWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.lassewolpmann.f1-countdown-ios.TimerWidget", provider: TimerTimelineProvider()) { entry in
            TimerWidgetView(entry: entry)
        }
        .configurationDisplayName("Timer")
        .description("Timer Widget to next F1 Grand Prix")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    TimerEntry(date: .now, raceName: RaceData().name, sessions: RaceData().sessions, flag: "", sessionLengths: APIConfig().sessionLengths)
}
