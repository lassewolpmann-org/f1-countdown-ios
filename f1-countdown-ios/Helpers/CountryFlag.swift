//
//  CountryFlag.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 27.11.2023.
//

import Foundation
import CoreLocation

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
