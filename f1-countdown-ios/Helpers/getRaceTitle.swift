//
//  getRaceTitle.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 21.11.2023.
//

import Foundation

func getRaceTitle(race: RaceData?) -> String {
    let name = race?.name ?? "undefined";
    
    if (name.contains("Grand Prix")) {
        return name
    } else {
        return "\(name) Grand Prix"
    }
}
