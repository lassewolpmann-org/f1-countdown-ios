//
//  DateFormatters.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 28.11.2023.
//

import Foundation

func getDay(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "EEEE dd. MMM YYYY";
    
    return formatter.string(from: date)
}

func getTime(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "HH:mm"
    
    return formatter.string(from: date)
}

func getOnlyDay(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "dd. MMM YYYY";
    
    return formatter.string(from: date)
}

func getDayName(date: Date) -> String {
    let formatter = DateFormatter();
    formatter.dateFormat = "EEEE";
    
    return formatter.string(from: date)
}
