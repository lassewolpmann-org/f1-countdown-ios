//
//  RaceWeather.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct WeatherElement: View {
    let labelText: String;
    let systemImage: String;
    let weatherText: String;
    
    var body: some View {
        HStack {
            Label(labelText, systemImage: systemImage)
                .foregroundStyle(.secondary)
            Spacer()
            Text(weatherText)
        }
        .font(.subheadline)
    }
}

struct SessionWeather: View {
    @Environment(\.dismiss) var dismiss
    
    @State var weather: WeatherData = WeatherData();
    
    let race: RaceData
    let session: SessionData
    
    var body: some View {
        NavigationStack {
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
                    Text("\(race.flag) \(race.location)")
                    Spacer()
                    Text(" Weather")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 10)
                
            }
            .navigationTitle(session.longName)
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .tint(.secondary)
                }
            }
            .padding()
            .task {
                await weather.getWeather(race: race, startDate: session.startDate, endDate: session.endDate)
            }
        }
    }
}

#Preview {
    VStack {
    }.sheet(isPresented: .constant(true)) {
        let nextRace = RaceData();
        SessionWeather(weather: WeatherData(), race: nextRace, session: SessionData(rawName: "undefined", startDate: Date.now, endDate: Date.now))
            .presentationDetents([.medium])
    }
}
