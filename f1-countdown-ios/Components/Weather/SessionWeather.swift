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
    let date: String;
    @State var weather: WeatherData;

    var body: some View {
        let date = ISO8601DateFormatter().date(from: date)!;

        // Making sure that the end date is within 7 days
        let sevenDaysInSeconds: Double = 7 * 24 * 60 * 60;
        if (date.timeIntervalSinceNow >= sevenDaysInSeconds) {
            VStack(alignment: .leading) {
                let weatherAvailabilityDate = date.addingTimeInterval(-sevenDaysInSeconds);
                Label("Weather Forecast will be available from \(Text(weatherAvailabilityDate, style: .date)), \(Text(weatherAvailabilityDate, style: .time)).", systemImage: "info.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } else {
            VStack(alignment: .leading, spacing: 15) {
                Text("Weather Forecast")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Text("for \(date, style: .date), \(date, style: .time)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                WeatherElement(labelText: "Conditions", systemImage: weather.symbol, weatherText: weather.condition)
                WeatherElement(labelText: "Chance of Rain", systemImage: "drop", weatherText: weather.rainChance)
                WeatherElement(labelText: "Temperature", systemImage: "thermometer.medium", weatherText: weather.temp)
                WeatherElement(labelText: "Feels like", systemImage: "thermometer.medium", weatherText: weather.apparentTemp)
            }
        }
    }
}

#Preview {
    SessionWeather(date: RaceData().futureSessions.first!.value, weather: WeatherData())
}
