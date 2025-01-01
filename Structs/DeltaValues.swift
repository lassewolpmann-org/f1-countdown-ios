//
//  DeltaValues.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 8.12.2023.
//

import Foundation

struct DeltaValues {
    var delta: Int
    
    var days: Int { self.delta / 86400 }
    var daysPct: Float { self.days > 7 ? Float(self.days % 7) / 7 : Float(self.days) / 7 }
    
    var hours: Int { self.delta % 86400 / 3600 }
    var hoursPct: Float { Float(self.hours) / 24 }
    
    var minutes: Int { self.delta % 86400 % 3600 / 60 }
    var minutesPct: Float { Float(self.minutes) / 60 }
    
    var seconds: Int { self.delta % 86400 % 3600 % 60 }
    var secondsPct: Float { Float(self.seconds) / 60 }
    
    init(date: Date) {
        self.delta = Int(date.timeIntervalSinceNow);
    }
}

func getDelta(session: SessionData) -> DeltaValues {
    let delta: DeltaValues
    let status = getSessionStatus(session: session)
    
    switch status {
    case .finished:
        delta = DeltaValues(date: .now)
    case .ongoing:
        delta = DeltaValues(date: session.endDate)
    case .upcoming:
        delta = DeltaValues(date: session.startDate)
    }
    
    return delta
}
