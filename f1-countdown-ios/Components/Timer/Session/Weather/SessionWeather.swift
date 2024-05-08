//
//  RaceWeather.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct SessionWeather: View {
    @State var weather: WeatherData = WeatherData();
    @State var weatherTimestamp: Date = Date();
    
    let nextRace: RaceData;
    let series: String;
    let sessionDate: String;
    let sessionName: String;

    var body: some View {
        let startDate = ISO8601DateFormatter().date(from: sessionDate)!;
        let sessionLength = nextRace.sessionLengths[series]?[sessionName] ?? 60;
        let endDate = startDate.addingTimeInterval(60 * sessionLength);

        // Making sure that the end date is within 10 days
        let forecastAvailability: Double = 7 * 24 * 60 * 60;
        
        VStack {
            if (endDate.timeIntervalSinceNow >= forecastAvailability) {
                Label("Weather Forecast is not available yet.", systemImage: "info.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .trailing, spacing: 10) {
                    WeatherElement(labelText: "Conditions", systemImage: weather.symbol, weatherText: weather.condition)
                    Divider()
                    WeatherElement(labelText: "Chance of Rain", systemImage: "drop", weatherText: weather.rainChance)
                    Divider()
                    WeatherElement(labelText: "Temperature", systemImage: "thermometer.medium", weatherText: weather.temp)
                            
                    Text(" Weather")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task {
            await weather.getWeather(race: nextRace, series: series, startDate: startDate, endDate: endDate, sessionName: sessionName)
        }
    }
}

#Preview {
    VStack {
        let nextRace = RaceData();
        let nextSession = nextRace.futureSessions.first!;
        SessionWeather(weather: WeatherData(), nextRace: nextRace, series: "f1", sessionDate: nextSession.value, sessionName: nextSession.key)
    }
}
