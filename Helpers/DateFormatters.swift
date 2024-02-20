//
//  DateFormatters.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 29.11.2023.
//

import Foundation

func getDayName(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "EEEE";
    
    return formatter.string(from: date)
}
