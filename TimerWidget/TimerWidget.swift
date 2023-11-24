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
    let sessionDate: Date;
    let sessionName: String;
    let flag: String;
}

struct TimerWidgetView: View {
    let entry: TimerEntry;
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("\(entry.flag) \(entry.raceName) Grand Prix".uppercased())
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Text(parseSessionName(name: entry.sessionName))
                    .font(.title)
            }.frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text(getDayName(date: entry.sessionDate))
                    .foregroundStyle(.red)
                
                HStack {
                    Text(getOnlyDay(date: entry.sessionDate))
                        .font(.title)
                    Spacer()
                    Text("from \(getTime(date: entry.sessionDate))")
                        .font(.title)
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .containerBackground(for: .widget) {
            VStack(spacing: 0) {
                Color(uiColor: .systemBackground)
                Color(uiColor: .secondarySystemBackground)
            }
        }
    }
}

struct TimerTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> TimerEntry {
        let date = Date();
        let sessionDate = ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!
        let sessionName = RaceData().sessions.first!.key;
        
        let entry = TimerEntry(date: date, raceName: RaceData().name, sessionDate: sessionDate, sessionName: sessionName, flag: "🇺🇳");
        
        return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (TimerEntry) -> Void) {
        let date = Date();
        let sessionDate = ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!
        let sessionName = RaceData().sessions.first!.key;
        
        let entry = TimerEntry(date: date, raceName: RaceData().name, sessionDate: sessionDate, sessionName: sessionName, flag: "🇺🇳");
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<TimerEntry>) -> Void) {
        Task {
            let nextRace = await getNextRace();
            let sessionDate = getSessionDate(race: nextRace);
            let sessionName = getSessionName(race: nextRace);
            let flag = await getCountryFlag(latitude: nextRace.latitude, longitude: nextRace.longitude);

            let date = Date();
            let entry = TimerEntry(date: date, raceName: nextRace.name, sessionDate: sessionDate, sessionName: sessionName, flag: flag);
            
            let nextUpdateDate = sessionDate;
            
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate));
            
            completion(timeline)
        }
    }
}

struct TimerWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.lassewolpmann.f1-countdown-ios", provider: TimerTimelineProvider()) { entry in
            TimerWidgetView(entry: entry)
        }
        .configurationDisplayName("Timer")
        .description("Timer Widget to next F1 Grand Prix")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    TimerWidget()
} timeline: {
    let sessionDate = ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!
    let sessionName = RaceData().sessions.first!.key;
    
    TimerEntry(date: .now, raceName: RaceData().name, sessionDate: sessionDate, sessionName: sessionName, flag: "🇺🇳")
}
