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
    var latitude: Double = RaceData().latitude;
    var longitude: Double = RaceData().longitude;
    var raceLocation: String = RaceData().location;
    var sessionDate: String?;
    
    @State var weather: WeatherData?;
    @State var flag: String?;
    
    var body: some View {
        Section {
            if ((weather) != nil) {
                HStack(alignment: .center) {
                    if ((flag) != nil) {
                        Text(flag ?? "🇺🇳");
                    } else {
                        ProgressView()
                    }
                    
                    Text(raceLocation)
                        .font(.title3)
                }
                
                VStack(alignment: .leading) {
                    if (weather?.temp != nil && weather?.rain != nil && weather?.description != nil && weather?.symbol != nil) {
                        Text(weather!.temp!)
                        Text("\(weather!.rain!) per hour" )
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
            } else {
                ProgressView()
            }
        }.task {
            weather = await getWeatherForecast(latitude: latitude, longitude: longitude, sessionDate: sessionDate);
            flag = await getCountryFlag(latitude: latitude, longitude: longitude);
        }
    }
}

func getWeatherForecast(latitude: Double, longitude: Double, sessionDate: String?) async -> WeatherData {
    let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude));

    let dateFormatter = ISO8601DateFormatter();
    let date = dateFormatter.date(from: sessionDate ?? "2023-11-28T10:00:00Z");
    
    let startDate = date!;
    let endDate = date!.addingTimeInterval(60 * 60 * 2);
    
    let weatherService = WeatherService();
    
    do {
        let hourlyForecast = try await weatherService.weather(for: location, including: .hourly(startDate: startDate, endDate: endDate));
        let forecast = hourlyForecast.first;
        
        let weather = WeatherData(symbol: forecast?.symbolName, temp: forecast?.temperature.description, rain: forecast?.precipitationAmount.description, description: forecast?.condition.description)
        
        return weather
    } catch {
        return WeatherData()
    }
}

func getCountryFlag(latitude: Double, longitude: Double) async -> String {
    let geocoder = CLGeocoder();
    
    let location = CLLocation(latitude: latitude, longitude: longitude);
    
    do {
        let reverseGeocodeLocation = try await geocoder.reverseGeocodeLocation(location);
        let countryCode = reverseGeocodeLocation.first?.isoCountryCode ?? "";
        
        let base: UInt32 = 127397
        var s = ""
        for v in countryCode.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        
        return s
    } catch {
        return "🇺🇳"
    }
}

#Preview {
    SessionWeather()
}
