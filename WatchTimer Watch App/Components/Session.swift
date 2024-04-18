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
    
    @State var weather: WeatherData = WeatherData();
    
    var body: some View {
        let startDate = ISO8601DateFormatter().date(from: sessionDate)!;
        let sessionLength = appData.nextRace.sessionLengths["f1"]?[sessionName] ?? 60;
        let endDate = startDate.addingTimeInterval(60 * sessionLength);
        
        ZStack(alignment: .top) {
            HStack {
                WeatherButton(showWeatherSheet: $showWeatherSheet)
                Spacer()
                InfoButton(showInfoSheet: $showInfoSheet)
            }
            .padding(.horizontal, 15)
            .padding(.top, -25)
            
            TimerCircle(deltaPct: delta.daysPct, ringColor: .primary)
            TimerCircle(deltaPct: delta.hoursPct, ringColor: .red)
                .padding(8)
            TimerCircle(deltaPct: delta.minutesPct, ringColor: .green)
                .padding(16)
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
        }
        .sheet(isPresented: $showWeatherSheet, content: {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Weather")
                        .font(.headline)
                    
                    Divider()
                    
                    HStack {
                        Label("Conditions", systemImage: "cloud")
                            .foregroundStyle(.secondary)
                            .labelStyle(.iconOnly)
                        Spacer()
                        Text(weather.condition)
                    }
                    
                    Divider()
                    
                    HStack {
                        Label("Chance of Rain", systemImage: "drop")
                            .foregroundStyle(.secondary)
                            .labelStyle(.iconOnly)
                        Spacer()
                        Text(weather.rainChance)
                    }
                    
                    Divider()
                    
                    HStack {
                        Label("Temperature", systemImage: "thermometer.sun")
                            .foregroundStyle(.secondary)
                            .labelStyle(.iconOnly)
                        Spacer()
                        Text(weather.temp)
                    }
                }
            }
        })
        .sheet(isPresented: $showInfoSheet, content: {
            VStack {
                Text("Session Date")
                    .font(.headline)
                
                Text("\(startDate, style: .date), \(DateInterval(start: startDate, end: endDate))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
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
        .task {
            await weather.getWeather(race: appData.nextRace, series: "f1", startDate: startDate, endDate: endDate, sessionName: sessionName)
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
