//
//  RaceWeather.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct WeatherData {
    var symbol: String?;
    var temp: String?;
    var apparentTemp: String?;
    var rain: String?;
    var description: String?;
}

struct SessionWeather: View {
    let race: RaceData;
    let name: String;
    let date: Date;
    let config: APIConfig;
    
    @State var weather: WeatherData?;
    @State var weatherAvailable: Bool = false;
    
    var body: some View {
        VStack(alignment: .leading) {
            if (weatherAvailable) {
                if ((weather) != nil) {
                    VStack(spacing: 5) {
                        HStack(spacing: 5) {
                            Text("\(Image(systemName: weather!.symbol!)) \(weather!.description!)")
                                .font(.title2)
                                .frame(
                                  minWidth: 0,
                                  maxWidth: .infinity,
                                  minHeight: 0,
                                  maxHeight: .infinity
                                )
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.tertiary.opacity(0.2).shadow(.drop(color: .primary, radius: 5)))
                                        .stroke(.tertiary, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text("\(Image(systemName: "drop")) Precipation")
                                    .foregroundStyle(.secondary)
                                Text(weather!.rain!)
                                    .font(.title2)
                            }
                            .frame(
                              minWidth: 0,
                              maxWidth: .infinity,
                              minHeight: 0,
                              maxHeight: .infinity
                            )
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.tertiary.opacity(0.2).shadow(.drop(color: .primary, radius: 5)))
                                    .stroke(.tertiary, lineWidth: 1)
                            )
                        }
                        
                        HStack(spacing: 5) {
                            VStack(alignment: .leading) {
                                Text("\(Image(systemName: "thermometer.medium")) Temperature")
                                    .foregroundStyle(.secondary)
                                Text(weather!.temp!)
                                    .font(.title2)
                            }
                            .frame(
                              minWidth: 0,
                              maxWidth: .infinity,
                              minHeight: 0,
                              maxHeight: .infinity
                            )
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.tertiary.opacity(0.2).shadow(.drop(color: .primary, radius: 5)))
                                    .stroke(.tertiary, lineWidth: 1)
                            )
                            
                            VStack(alignment: .leading) {
                                Text("\(Image(systemName: "thermometer.medium")) Feels like")
                                    .foregroundStyle(.secondary)
                                Text(weather!.apparentTemp!)
                                    .font(.title2)
                            }
                            .frame(
                              minWidth: 0,
                              maxWidth: .infinity,
                              minHeight: 0,
                              maxHeight: .infinity
                            )
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.tertiary.opacity(0.2).shadow(.drop(color: .primary, radius: 5)))
                                    .stroke(.tertiary, lineWidth: 1)
                            )
                        }
                    }
                } else {
                    ProgressView()
                }
            } else {
                HStack(alignment: .center) {
                    Image(systemName: "info.circle.fill").opacity(0.15)
                    Text("Weather forecast becomes available within 10 days of session date.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(
                  minWidth: 0,
                  maxWidth: .infinity
                )
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.tertiary.opacity(0.2).shadow(.drop(color: .primary, radius: 5)))
                        .stroke(.tertiary, lineWidth: 1)
                )
            }
        }.task {
            if (date.timeIntervalSinceNow < (60 * 60 * 24 * 10)) {
                weatherAvailable = true;
                weather = await getWeatherForecast(latitude: race.latitude, longitude: race.longitude, date: date, config: config, name: name);
            } else {
                weather = WeatherData();
            }
            
        }
    }
}

func getWeatherForecast(latitude: Double, longitude: Double, date: Date, config: APIConfig, name: String) async -> WeatherData {
    let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude));
    
    let startDate = date;
    let sessionLength = Double(config.sessionLengths[name] ?? Int(60.0));
    let endDate = date.addingTimeInterval(60 * sessionLength);

    do {
        let hourlyForecast = try await WeatherService().weather(for: location, including: .hourly(startDate: startDate, endDate: endDate));
        let forecast = hourlyForecast.first;
        
        let weather = WeatherData(symbol: forecast?.symbolName, temp: forecast?.temperature.description, apparentTemp: forecast?.apparentTemperature.description, rain: forecast?.precipitationAmount.description, description: forecast?.condition.description)
        
        return weather
    } catch {
        return WeatherData()
    }
}

#Preview {
    List {
        Section {
            SessionWeather(race: RaceData(), name: RaceData().sessions.first!.key, date: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, config: APIConfig())
        }
    }
}
