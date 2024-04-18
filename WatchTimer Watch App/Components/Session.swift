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
            // Making sure that the end date is within 10 days
            let forecastAvailability: Double = 10 * 24 * 60 * 60;
            
            if (endDate.timeIntervalSinceNow >= forecastAvailability) {
                VStack(alignment: .leading) {
                    let weatherAvailabilityDate = startDate.addingTimeInterval(-forecastAvailability);
                    Label("Weather Forecast will be available from \(Text(weatherAvailabilityDate, style: .date)), \(Text(weatherAvailabilityDate, style: .time)).", systemImage: "info.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(10)
            } else {
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
                        
                        Text(" Weather")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 20)
                    }
                    .padding(10)
                }
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
