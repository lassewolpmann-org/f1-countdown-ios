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
    let flags: [String: String];
    let sessionDate: String;
    
    @State var weather: WeatherData?;
    @State var weatherAvailable: Bool = false;
    
    var body: some View {
        Section {
            HStack(alignment: .center) {
                Text(flags[race.localeKey] ?? "")
                Text(race.location)
                    .font(.title3)
            }

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
            }
        }.task {
            let date = ISO8601DateFormatter().date(from: sessionDate)!;
            
            if (date.timeIntervalSinceNow < (60 * 60 * 24 * 10)) {
                weather = await getWeatherForecast(latitude: race.latitude, longitude: race.longitude, date: date);
                weatherAvailable = true;
            } else {
                weather = WeatherData();
            }
            
        }
    }
}

func getWeatherForecast(latitude: Double, longitude: Double, date: Date) async -> WeatherData {
    let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude));
    
    let startDate = date;
    let endDate = date.addingTimeInterval(60 * 60 * 2);

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
    SessionWeather(race: RaceData(), flags: [:], sessionDate: RaceData().sessions.first!.value)
}
