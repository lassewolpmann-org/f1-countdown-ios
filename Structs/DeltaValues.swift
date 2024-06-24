//
//  DeltaValues.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 8.12.2023.
//

import Foundation

struct DeltaValues {
    var delta: Int;
    
    var days: Int;
    var daysPct: Float;
    
    var hours: Int;
    var hoursPct: Float;
    
    var minutes: Int;
    var minutesPct: Float;
    
    var seconds: Int;
    var secondsPct: Float;
    
    init(date: Date) {
        self.delta = Int(date.timeIntervalSinceNow);
        
        if (self.delta < 0) {
            self.delta = 0;
        }
        
        self.days = self.delta / 86400;
        
        if (self.days > 7) {
            daysPct = Float(self.days % 7) / 7;
        } else {
            daysPct = Float(self.days) / 7
        }
        
        self.hours = self.delta % 86400 / 3600;
        self.hoursPct = Float(self.hours) / 24;
        
        self.minutes = self.delta % 86400 % 3600 / 60;
        self.minutesPct = Float(self.minutes) / 60;
        
        self.seconds = self.delta % 86400 % 3600 % 60;
        self.secondsPct = Float(self.seconds) / 60;
    }
}
