//
//  WeatherData.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 20.2.2024.
//

import Foundation
import CoreLocation
import WeatherKit

class WeatherData {
    private let formatter = MeasurementFormatter();
    private let service = WeatherService();
    
    var weather: HourWeather?
    var available: Bool = true;
    
    init() {
        formatter.numberFormatter.maximumFractionDigits = 2;
        formatter.unitStyle = .medium;
    }
    
    func getWeather(race: RaceData, startDate: Date, endDate: Date) async {
        // We know, that the Weather Forecast is only available for 10 days in the future. This prevents unnecessary API calls.
        if (endDate.timeIntervalSinceNow >= 10 * 24 * 60 * 60) {
            self.available = false;
            return
        }
        
        let location = CLLocation(latitude: CLLocationDegrees(race.latitude), longitude: CLLocationDegrees(race.longitude));
        
        do {
            let hourly = try await service.weather(for: location, including: .hourly(startDate: startDate, endDate: startDate.addingTimeInterval(60 * 60)));
            self.weather = hourly.forecast.first!;
            self.available = true;
            
            return
        } catch {
            print(error)
            self.available = false;
            
            return
        }
    }
    
    var symbol: String {
        weather?.symbolName ?? "xmark"
    }
    
    var temp: String {
        if let temp = weather?.temperature {
            return formatter.string(from: temp)
        } else {
            return "Loading..."
        }
    }
    
    var rainChance: String {
        weather?.precipitationChance.formatted(.percent).description ?? "Loading..."
    }
    
    var condition: String {
        weather?.condition.description ?? "Loading..."
    }
    
    var windSpeed: String {
        if let windSpeed = weather?.wind.speed {
            return formatter.string(from: windSpeed)
        } else {
            return "Loading..."
        }
    }
}
