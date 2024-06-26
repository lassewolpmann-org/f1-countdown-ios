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
    let race: RaceData
    let date: Date
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
            Label {
                Text("Formula Countdown Widget is not available in this size.")
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
        let race = RaceData(
            name: "Loading Grand Prix...",
            sessions: [:]
        )
        
        return TimerEntry(race: race, date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> Void) {
        Task {
            let appData = AppData()
            
            do {
                appData.races = try await appData.getAllRaces();
            } catch {
                print(error)
            }
            
            let entry = TimerEntry(
                race: appData.nextRace ?? RaceData(),
                date: Date()
            )
            
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> Void) {
        Task {
            let appData = AppData()
            
            do {
                appData.races = try await appData.getAllRaces();
            } catch {
                print(error)
            }
            
            let race = appData.nextRace ?? RaceData()
            
            let entry = TimerEntry(
                race: race,
                date: Date()
            )
                        
            let nextUpdateDate = getNextUpdateDate(nextRace: race)
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate));
            
            completion(timeline)
        }
    }
}

struct TimerWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.lassewolpmann.f1-countdown-ios.TimerWidget", provider: TimerWidgetProvider()) { entry in
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
    TimerEntry(race: RaceData(), date: Date())
}
