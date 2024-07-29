//
//  SessionWeather.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 29.7.2024.
//

import SwiftUI

struct SessionWeather: View {
    @State var weather: WeatherData = WeatherData();
    let race: RaceData
    let session: SessionData

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if (weather.available) {
                WeatherElement(labelText: "Conditions", systemImage: weather.symbol, weatherText: weather.condition)
                Divider()
                WeatherElement(labelText: "Chance of Rain", systemImage: "drop", weatherText: weather.rainChance)
                Divider()
                WeatherElement(labelText: "Temperature", systemImage: "thermometer.medium", weatherText: weather.temp)
                Divider()
                WeatherElement(labelText: "Wind Speed", systemImage: "wind", weatherText: weather.windSpeed)
            } else {
                Label("Weather Forecast is not available.", systemImage: "info.circle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .labelStyle(.titleAndIcon)
            }
            
            HStack {
                Text(session.startDate, style: .date)
                Spacer()
                Text(DateInterval(start: session.startDate, end: session.endDate))
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.top, 10)
            
            HStack {
                Text("\(race.flag) \(race.location)")
                Spacer()
                Text(" Weather")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            
        }
        .padding()
        .task {
            await weather.getWeather(race: race, startDate: session.startDate, endDate: session.endDate)
        }
    }
}

#Preview {
    SessionWeather(race: RaceData(), session: SessionData(rawName: "undefined"))
}
