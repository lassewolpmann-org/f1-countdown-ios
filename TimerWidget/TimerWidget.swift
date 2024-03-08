//
//  TimerWidget.swift
//  TimerWidget
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import WidgetKit
import SwiftUI

struct TimerEntry: TimelineEntry {
    let race: RaceData;
    let date: Date = Date();
    let tbc: Bool;
    let flag: String;
    let sessionLengths: [String: [String: Double]];
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
        return TimerEntry(race: RaceData(), tbc: false, flag: "", sessionLengths: RaceData().sessionLengths)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> Void) {
        Task {
            completion(await createEntry())
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> Void) {
        Task {
            do {
                let appData = AppData(series: "f1");
                appData.races = try await appData.getAllRaces();
                let nextRace = appData.nextRace;
                let nextSession = nextRace.futureSessions.first!;
                let date = ISO8601DateFormatter().date(from: nextSession.value) ?? Date();

                let timeline = Timeline(entries: [await createEntry()], policy: .after(date));
                
                completion(timeline)
            } catch {
                let nextRace = RaceData();
                let nextSession = nextRace.futureSessions.first!;
                let date = ISO8601DateFormatter().date(from: nextSession.value) ?? Date();
                
                let timeline = Timeline(entries: [await createEntry()], policy: .after(date));
                
                completion(timeline)
            }
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
    TimerEntry(race: RaceData(), tbc: true, flag: "", sessionLengths: RaceData().sessionLengths)
}
