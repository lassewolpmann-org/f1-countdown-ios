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
    
    func getWeather(race: RaceData, series: String, startDate: Date, endDate: Date, sessionName: String) async {
        if (endDate.timeIntervalSinceNow >= 10 * 24 * 60 * 60) { return }
        
        let location = CLLocation(latitude: CLLocationDegrees(race.latitude), longitude: CLLocationDegrees(race.longitude));
        
        do {
            let hourly = try await service.weather(for: location, including: .hourly(startDate: startDate, endDate: endDate));
            self.weather = hourly.forecast.first!;
            return
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
