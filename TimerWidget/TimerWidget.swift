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
        return TimerEntry(race: RaceData(), tbc: false, flag: "", sessionLengths: DataConfig().sessionLengths)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> Void) {
        Task {
            completion(await createEntry())
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> Void) {
        Task {
            do {
                let nextRace = try await AppData().nextRace;

                let timeline = Timeline(entries: [await createEntry()], policy: .after(getNextUpdateDate(nextRace: nextRace)));
                
                completion(timeline)
            } catch {
                let timeline = Timeline(entries: [await createEntry()], policy: .after(getNextUpdateDate(nextRace: RaceData())));
                
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
    TimerEntry(race: RaceData(), tbc: true, flag: "", sessionLengths: DataConfig().sessionLengths)
}
