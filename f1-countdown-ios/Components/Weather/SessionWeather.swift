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
        
        // Making sure that the end date is within 10 days (240 hours)
        if (date.timeIntervalSinceNow >= 238 * 60 * 60) {
            Label("Weather forecast is not available yet.", systemImage: "info.circle.fill")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else {
            VStack(alignment: .leading, spacing: 15) {
                Text("Weather Forecast")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .bold()
                
                HStack {
                    Spacer()
                    Label(weather.condition, systemImage: weather.symbol)
                        .font(.title2)
                }
                Divider()
                HStack {
                    Label("Chance of Rain", systemImage: "drop")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(weather.rainChance).font(.title2)
                }
                Divider()
                HStack {
                    Text("\(Image(systemName: "thermometer.medium")) Temperature")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(weather.temp).font(.title2)
                }
                Divider()
                HStack {
                    Text("\(Image(systemName: "thermometer.medium")) Feels like")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(weather.apparentTemp).font(.title2)
                }
            }
            .task {
                await weather.getWeather(latitude: race.latitude, longitude: race.longitude, startDate: date, endDate: endDate, config: config, name: name);
            }
        }
        
        
    }
}

#Preview {
    List {
        Section {
            SessionWeather(race: RaceData(), name: RaceData().sessions.first!.key, date: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, config: DataConfig())
        }
    }
}
