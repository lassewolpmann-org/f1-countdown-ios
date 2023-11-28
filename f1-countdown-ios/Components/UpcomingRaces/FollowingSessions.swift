//
//  FutureSessions.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 28.11.2023.
//

import SwiftUI

struct FollowingSessions: View {
    let race: RaceData;
    let flags: [String: String];
    
    var body: some View {
        let sortedSessions = race.sessions.sorted(by:{$0.value < $1.value});
        let futureSessions = sortedSessions.filter { (key: String, value: String) in
            let formatter = ISO8601DateFormatter();
            let date = formatter.date(from: value)!;
            
            return date.timeIntervalSinceNow > 0
        }
        
        let followingSessions = futureSessions.dropFirst();
        
        if (followingSessions.count > 0) {
            Section {
                ForEach(followingSessions, id:\.key) { session in
                    let name = parseSessionName(sessionName: session.key);
                    let date = ISO8601DateFormatter().date(from: session.value)!;
                    
                    NavigationLink(name) {
                        List {
                            SessionDetails(race: race, flags: flags, name: name, date: date)
                        }.navigationTitle(name)
                    }
                }
            } header: {
                Text("Following sessions")
            }
        }
    }
}

#Preview {
    FollowingSessions(race: RaceData(), flags: [:])
}
