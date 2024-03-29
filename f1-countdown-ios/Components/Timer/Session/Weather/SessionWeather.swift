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
    @Binding var showWeatherForecast: Bool;
    
    let nextRace: RaceData;
    let series: String;
    let sessionDate: String;
    let sessionName: String;

    var body: some View {
        let startDate = ISO8601DateFormatter().date(from: sessionDate)!;
        let sessionLength = nextRace.sessionLengths[series]?[sessionName] ?? 60;
        let endDate = startDate.addingTimeInterval(60 * sessionLength);

        // Making sure that the end date is within 10 days
        let forecastAvailability: Double = 10 * 24 * 60 * 60;
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Session Date")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text("\(startDate, style: .date), \(DateInterval(start: startDate, end: endDate))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if (startDate.timeIntervalSinceNow >= forecastAvailability) {
                    VStack(alignment: .leading) {
                        let weatherAvailabilityDate = startDate.addingTimeInterval(-forecastAvailability);
                        Label("Weather Forecast will be available from \(Text(weatherAvailabilityDate, style: .date)), \(Text(weatherAvailabilityDate, style: .time)).", systemImage: "info.circle.fill")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Weather Forecast")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        WeatherElement(labelText: "Conditions", systemImage: weather.symbol, weatherText: weather.condition)
                        WeatherElement(labelText: "Chance of Rain", systemImage: "drop", weatherText: weather.rainChance)
                        WeatherElement(labelText: "Temperature", systemImage: "thermometer.medium", weatherText: weather.temp)
                        WeatherElement(labelText: "Feels like", systemImage: "thermometer.medium", weatherText: weather.apparentTemp)
                    }
                }
            }
            .padding(20)
            .task {
                await weather.getWeather(race: nextRace, series: series, startDate: startDate, endDate: endDate, sessionName: sessionName)
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        showWeatherForecast.toggle();
                    } label: {
                        Label("Close", systemImage: "xmark.circle.fill")
                    }
                    .tint(.secondary)
                }
            }
        }
    }
}

#Preview {
    VStack {
        Text("Weather")
    }
    .sheet(isPresented: .constant(true), content: {
        let nextRace = RaceData();
        let nextSession = nextRace.futureSessions.first!;
        SessionWeather(weather: WeatherData(), showWeatherForecast: .constant(true), nextRace: nextRace, series: "f1", sessionDate: nextSession.value, sessionName: nextSession.key)
        .presentationDetents([.medium])
    })
}
