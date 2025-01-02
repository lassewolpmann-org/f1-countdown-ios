//
//  TimerWidget.swift
//  TimerWidget
//
//  Created by Lasse Wolpmann on 23.11.2023.
//

import WidgetKit
import SwiftUI
import SwiftData

enum TimerWidgetError: Error {
    case nextUpdateError(String)
}

struct TimerEntry: TimelineEntry {
    let date: Date
}

struct TimerWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily;
    @Query var allRaces: [RaceData]
    
    var nextRace: RaceData? {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: .now)
        let currentSeries = allRaces.filter { $0.series == "f1" }
        let currentSeason = currentSeries.filter { $0.season == currentYear }
        let futureRaces = currentSeason.filter { $0.endDate > Date() }
        let sortedRaces = futureRaces.sorted { $0.startDate < $1.startDate }
        
        return sortedRaces.first
    }
    
    let entry: TimerEntry;

    @ViewBuilder
    var body: some View {
        if let nextRace {
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
                Large(race: nextRace.race)
            case .systemMedium:
                Medium(race: nextRace.race)
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
        return TimerEntry(date: Date.now.addingTimeInterval(3600))
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> Void) {
        completion(TimerEntry(date: Date.now.addingTimeInterval(3600)))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> Void) {
        let timeline = Timeline(entries: [TimerEntry(date: Date.now.addingTimeInterval(3600))], policy: .atEnd);
        
        completion(timeline)
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
    TimerEntry(date: Date.now.addingTimeInterval(3600))
}
