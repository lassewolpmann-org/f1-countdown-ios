//
//  RaceDetails.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.11.2023.
//

import SwiftUI
import CoreLocation
import WeatherKit

struct RaceDetails: View {
    let race: RaceData;
    let flags: [String: String];
    
    var body: some View {
        NavigationStack {
            List {
                // First Session
                FirstSession(race: race, flags: flags)
                
                // Future Sessions
                FollowingSessions(race: race, flags: flags)
            }
        }.navigationTitle(parseSessionName(sessionName: getFirstSession(race: race).key))
    }
}

func getFirstSession(race: RaceData) -> Dictionary<String, String>.Element {
    let sortedSessions = race.sessions.sorted(by:{$0.value < $1.value});
    let futureSessions = sortedSessions.filter { (key: String, value: String) in
        let formatter = ISO8601DateFormatter();
        let date = formatter.date(from: value)!;
        
        return date.timeIntervalSinceNow > 0
    }
    
    return futureSessions.first!
}

#Preview {
    RaceDetails(race: RaceData(), flags: [:])
}
