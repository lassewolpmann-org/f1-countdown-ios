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
    @Query var allSeries: [SeriesData]
    var currentSeries: SeriesData? { allSeries.filter({ $0.series == "f1" }).first }
    var nextRace: Season.Race? { currentSeries?.nextRace }
    
    let entry: TimerEntry;

    @ViewBuilder
    var body: some View {
        if let nextRace = currentSeries?.nextRace {
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
                Large(race: nextRace)
            case .systemMedium:
                Medium(race: nextRace)
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
                .modelContainer(for: [SeriesData.self])
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
