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
    let race: RaceData;
    let name: String;
    let date: Date;
    let config: DataConfig;
    
    @State private var weather = WeatherData();

    var body: some View {
        let sessionLength = Double(config.sessionLengths[name] ?? Int(60.0));
        let endDate = date.addingTimeInterval(60 * sessionLength);
        
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
                    .font(.title)
                    .foregroundStyle(.secondary)
                
                WeatherElement(labelText: "Conditions", systemImage: weather.symbol, weatherText: weather.condition)
                WeatherElement(labelText: "Chance of Rain", systemImage: "drop", weatherText: weather.rainChance)
                WeatherElement(labelText: "Temperature", systemImage: "thermometer.medium", weatherText: weather.temp)
                WeatherElement(labelText: "Feels like", systemImage: "thermometer.medium", weatherText: weather.apparentTemp)
            }
            .task {
                await weather.getWeather(latitude: race.latitude, longitude: race.longitude, startDate: date, endDate: endDate, config: config, name: name);
            }
        }
    }
}

#Preview {
    SessionWeather(race: RaceData(), name: RaceData().futureSessions.first!.key, date: ISO8601DateFormatter().date(from: RaceData().futureSessions.first!.value)!, config: DataConfig())
}
