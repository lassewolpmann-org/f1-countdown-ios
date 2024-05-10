//
//  Session.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct Session: View {
    @Environment(AppData.self) private var appData;
    let sessionDate: String;
    let sessionName: String;
    
    @State var delta: deltaValues;
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect();
    
    @State var showWeatherSheet: Bool = false;
    @State var showInfoSheet: Bool = false;
    
    var body: some View {
        let startDate = ISO8601DateFormatter().date(from: sessionDate)!;
        let sessionLength = appData.nextRace.sessionLengths["f1"]?[sessionName] ?? 60;
        let endDate = startDate.addingTimeInterval(60 * sessionLength);
        
        ZStack(alignment: .bottom) {
            TimerCircle(deltaPct: delta.daysPct, ringColor: .primary)
                .padding(6)
            TimerCircle(deltaPct: delta.hoursPct, ringColor: .red)
                .padding(12)
            TimerCircle(deltaPct: delta.minutesPct, ringColor: .green)
                .padding(18)
            TimerCircle(deltaPct: delta.secondsPct, ringColor: .blue)
                .padding(24)
                .background(
                    VStack {
                        Text("\(appData.nextRace.flag) \(parseShortSessionName(sessionName: sessionName))")
                            .font(.headline)
                        
                        Text(startDate, style: .timer)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                )
            
            HStack {
                WeatherButton(showWeatherSheet: $showWeatherSheet)
                Spacer()
                InfoButton(showInfoSheet: $showInfoSheet)
            }
        }
        .sheet(isPresented: $showWeatherSheet, content: {
            ScrollView {
                SessionWeather(race: appData.nextRace, series: appData.series, sessionDate: sessionDate, sessionName: sessionName)
                    .labelStyle(.iconOnly)
            }
        })
        .sheet(isPresented: $showInfoSheet, content: {
            VStack(alignment: .leading) {
                Text("Session Date")
                    .font(.headline)
                Text("\(startDate, style: .date), \(DateInterval(start: startDate, end: endDate))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Divider()
                
                Text("Location")
                    .font(.headline)
                Text(appData.nextRace.location)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(10)
        })
        .onReceive(timer) { _ in
            delta = deltaValues(dateString: sessionDate);
            
            if (delta.delta == 0) {
                Task {
                    do {
                        appData.races = try await appData.getAllRaces();
                    } catch {
                        print("\(error), while updating appData in Session")
                    }
                }
            }
        }
    }
}

#Preview {
    TabView {
        let nextRace = RaceData();
        let firstSession = nextRace.futureSessions.first!;
        
        Session(sessionDate: firstSession.value, sessionName: firstSession.key, delta: deltaValues(dateString: Date().ISO8601Format()))
            .environment(AppData(series: "f1"))
    }
    .tabViewStyle(.verticalPage)
}
