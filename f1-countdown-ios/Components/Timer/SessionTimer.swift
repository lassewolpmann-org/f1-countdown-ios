//
//  Timer.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 15.11.2023.
//

import SwiftUI

class deltaValues {
    var delta: Int;
    
    var days: Int;
    var daysPct: Float;
    
    var hours: Int;
    var hoursPct: Float;
    
    var minutes: Int;
    var minutesPct: Float;
    
    var seconds: Int;
    var secondsPct: Float;
    
    init(date: String) {
        self.delta = Int(formatDate(dateString: date).timeIntervalSince1970 - Date().timeIntervalSince1970);
        
        self.days = self.delta / 86400;
        
        if (self.days > 7) {
            daysPct = Float(self.days % 7) / 7;
        } else {
            daysPct = Float(self.days) / 7
        }
        
        self.hours = self.delta % 86400 / 3600;
        self.hoursPct = Float(self.hours / 24);
        
        self.minutes = self.delta % 86400 % 3600 / 60;
        self.minutesPct = Float(self.minutes) / 60;
        
        self.seconds = self.delta % 86400 % 3600 % 60;
        self.secondsPct = Float(self.seconds) / 60;
    }
}

func calculateDelta(date: String) -> Int {
    return Int(formatDate(dateString: date).timeIntervalSince1970 - Date().timeIntervalSince1970)
}

struct SessionTimer: View {
    @Environment(\.scenePhase) var scenePhase
    var currentSessionDate: String;
    
    @State var timer: Timer?;
    @State var delta: deltaValues = deltaValues(date: "1970-01-01T00:00:00Z");
    
    var body: some View {
        VStack {
            HStack {
                TimerElement(delta: delta.days, deltaPct: delta.daysPct, ringColor: .red, timeUnit: "days")
                TimerElement(delta: delta.hours, deltaPct: delta.hoursPct, ringColor: .yellow, timeUnit: "hours")
            }
            
            HStack {
                TimerElement(delta: delta.minutes, deltaPct: delta.minutesPct, ringColor: .green, timeUnit: "minutes")
                TimerElement(delta: delta.seconds, deltaPct: delta.secondsPct, ringColor: .blue, timeUnit: "seconds")
            }
        }
        .onChange(of: currentSessionDate, initial: true) {
            delta = deltaValues(date: currentSessionDate);
            
            timer?.invalidate();
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                delta = deltaValues(date: currentSessionDate);
            })
        }
        .onChange(of: scenePhase) {
            delta = deltaValues(date: currentSessionDate);
        }
    }
}

#Preview {
    SessionTimer(currentSessionDate: "1970-01-01T00:00:00Z")
}
