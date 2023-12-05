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
                Text(weather!.temp!)
                Text("\(weather!.rain!) per hour")
                HStack {
                    Text(Image(systemName: weather!.symbol!))
                    Text(weather!.description!)
                }
            } else {
                HStack(alignment: .center) {
                    Image(systemName: "info.circle.fill").opacity(0.15)
                    Text("Weather forecast becomes available within 10 days of session date.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }.task {
            if (date.timeIntervalSinceNow < (60 * 60 * 24 * 10)) {
                weather = await getWeatherForecast(latitude: race.latitude, longitude: race.longitude, date: date, config: config, name: name);
                weatherAvailable = true;
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
        
        let weather = WeatherData(symbol: forecast?.symbolName, temp: forecast?.temperature.description, rain: forecast?.precipitationAmount.description, description: forecast?.condition.description)
        
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
