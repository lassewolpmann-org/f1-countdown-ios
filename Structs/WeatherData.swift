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
    private let service = WeatherService();
    var weather: HourWeather?
    
    func getWeather(latitude: Double, longitude: Double, startDate: Date, endDate: Date, config: DataConfig, name: String) async {
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude));
        
        do {
            let hourly = try await service.weather(for: location, including: .hourly(startDate: startDate, endDate: endDate));
            weather = hourly.forecast.first!;
        } catch {
            print(error)
            return
        }
    }
    
    var symbol: String {
        weather?.symbolName ?? "xmark"
    }
    
    var temp: String {
        weather?.temperature.description ?? "Loading..."
    }
    
    var apparentTemp: String {
        weather?.apparentTemperature.description ?? "Loading..."
    }
    
    var rainChance: String {
        weather?.precipitationChance.formatted(.percent).description ?? "Loading..."
    }
    
    var condition: String {
        weather?.condition.description ?? "Loading..."
    }
}
