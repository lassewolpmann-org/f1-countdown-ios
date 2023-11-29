//
//  DateFormatters.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 28.11.2023.
//

import Foundation

func getTime(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "HH:mm"
    
    return formatter.string(from: date)
}

func getDate(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "dd. MMM YYYY";
    
    return formatter.string(from: date)
}

func getDayName(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "EEEE";
    
    return formatter.string(from: date)
}
