//
//  RaceTitle.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import Foundation

func getRaceTitle(race: RaceData) -> String {
    let name = race.name;
    let flag = CountryFlags().flags[race.localeKey] ?? "🏳️";
    
    if (name.contains("Grand Prix")) {
        return "\(flag) \(name)"
    } else {
        return "\(flag) \(name) Grand Prix"
    }
}
