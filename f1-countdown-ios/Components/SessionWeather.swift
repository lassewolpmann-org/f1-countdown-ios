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
    var latitude: Double;
    var longitude: Double;
    var sessionDate: String?;
    
    @State var hourlyForecast: Forecast<HourWeather>?;
    
    @State var weatherLocation: String?;
    @State var weatherSymbol: String?;
    @State var temp: String?;
    @State var rain: String?;
    @State var weatherDescription: String?;
    
    var body: some View {
        VStack(alignment: .leading) {
            if ((temp) != nil) {
                Text(temp ?? "Temperature")
                    .font(.title)
                    .padding(.bottom, 5)
                
                HStack {
                    Text(Image(systemName: weatherSymbol ?? "questionmark"))
                    Text(weatherDescription ?? "Description")
                }
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude));

                let dateFormatter = ISO8601DateFormatter();
                let date = dateFormatter.date(from: sessionDate ?? "2023-11-19T10:00:00Z");
                
                let startDate = date!;
                let endDate = date!.addingTimeInterval(60 * 60 * 2);
                
                let weatherService = WeatherService();
                hourlyForecast = try await weatherService.weather(for: location, including: .hourly(startDate: startDate, endDate: endDate));
                
                let forecast = hourlyForecast?.first;
                weatherSymbol = forecast?.symbolName;
                temp = forecast?.temperature.description;
                rain = forecast?.precipitationAmount.description;
                weatherDescription = forecast?.condition.description;
            } catch {
                weatherSymbol = "cloud";
                temp = "-";
                rain = "-";
                weatherDescription = "-";
            }
        }
    }
}

#Preview {
    SessionWeather(latitude: 0.0, longitude: 0.0)
}
