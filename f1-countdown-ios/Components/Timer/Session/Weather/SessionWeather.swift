//
//  RaceWeather.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct SessionWeather: View {
    @State var weather: WeatherData = WeatherData();
    
    let race: RaceData;
    let series: String;
    let sessionDate: String;
    let sessionName: String;
    
    var body: some View {
        let startDate = ISO8601DateFormatter().date(from: sessionDate)!;
        let sessionLength = race.sessionLengths[series]?[sessionName] ?? 60;
        let endDate = startDate.addingTimeInterval(60 * sessionLength);
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Weather Forecast for \(parseSessionName(sessionName: sessionName))")
                .font(.headline)
            
            Text("\(race.flag) \(race.location)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            VStack(spacing: 10) {
                if (weather.available) {
                    VStack(alignment: .trailing, spacing: 10) {
                        WeatherElement(labelText: "Conditions", systemImage: weather.symbol, weatherText: weather.condition)
                        Divider()
                        WeatherElement(labelText: "Chance of Rain", systemImage: "drop", weatherText: weather.rainChance)
                        Divider()
                        WeatherElement(labelText: "Temperature", systemImage: "thermometer.medium", weatherText: weather.temp)
                        Divider()
                        WeatherElement(labelText: "Wind Speed", systemImage: "wind", weatherText: weather.windSpeed)
                                
                        Text(" Weather")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Label("Weather Forecast is not available.", systemImage: "info.circle.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .labelStyle(.titleAndIcon)
                }
            }
            .padding(10)
            .background(.ultraThinMaterial, in:
                RoundedRectangle(cornerRadius: 10)
            )
        }
        .padding(10)
        .task {
            await weather.getWeather(race: race, startDate: startDate, endDate: endDate)
        }
    }
}

#Preview {
    VStack {
    }.sheet(isPresented: .constant(true)) {
        let nextRace = RaceData();
        let nextSession = nextRace.futureSessions.first!;
        SessionWeather(weather: WeatherData(), race: nextRace, series: "f1", sessionDate: nextSession.value, sessionName: nextSession.key)
            .presentationDetents([.medium])
    }
}
