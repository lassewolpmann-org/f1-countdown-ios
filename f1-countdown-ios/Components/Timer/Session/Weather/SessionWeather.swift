//
//  RaceWeather.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct SessionWeather: View {
    @State var weather: WeatherData = WeatherData();
    
    let race: RaceData
    let series: String
    let session: SessionData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(session.formattedName)
                .font(.headline)
            
            HStack {
                Text(session.startDate, style: .date)
                Spacer()
                Text(DateInterval(start: session.startDate, end: session.endDate))
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.bottom, 10)
            
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
                Text("\(race.flag) \(race.location)")
                Spacer()
                Text(" Weather")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .padding(.top, 10)
            
        }
        .padding(10)
        .task {
            await weather.getWeather(race: race, startDate: session.startDate, endDate: session.endDate)
        }
    }
}

#Preview {
    VStack {
    }.sheet(isPresented: .constant(true)) {
        let nextRace = RaceData();
        SessionWeather(weather: WeatherData(), race: nextRace, series: "f1", session: SessionData())
            .presentationDetents([.medium])
    }
}
