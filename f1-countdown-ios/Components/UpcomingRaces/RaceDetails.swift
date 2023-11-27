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
                let sortedSessions = race.sessions.sorted(by:{$0.value < $1.value});
                let futureSessions = sortedSessions.filter { (key: String, value: String) in
                    let formatter = ISO8601DateFormatter();
                    let date = formatter.date(from: value)!;
                    
                    return date.timeIntervalSinceNow > 0
                }
                
                let firstSession = futureSessions.first!;
                let followingSessions = futureSessions.dropFirst();
                
                SessionDetails(race: race, flags: flags, sessionName: firstSession.key, sessionDate: firstSession.value)
                
                if (followingSessions.count > 0) {
                    Section {
                        ForEach(followingSessions, id: \.key) { session in
                            NavigationLink(parseSessionName(sessionName: session.key)) {
                                List {
                                    SessionDetails(race: race, flags: flags, sessionName: session.key, sessionDate: session.value)
                                }.navigationTitle("Session information")
                            }
                        }
                    } header: {
                        Text("Following sessions")
                    }
                }
            }
            .navigationTitle(getRaceTitle(race: race))
        }
    }
}

func parseSessionName(sessionName: String?) -> String {
    let name = sessionName ?? "undefined"
    
    if (name == "fp1") {
        return "Free Practice 1"
    } else if (name == "fp2") {
        return "Free Practice 2"
    } else if (name == "fp3") {
        return "Free Practice 3"
    } else if (name == "qualifying") {
        return "Qualifying"
    } else if (name == "sprintQualifying") {
        return "Sprint Qualifying"
    } else if (name == "gp") {
        return "Race"
    } else {
        return "undefined"
    }
}

func getDay(dateString: String) -> String {
    let date = ISO8601DateFormatter().date(from: dateString)!;
    
    let formatter = DateFormatter();
    formatter.dateFormat = "EEEE dd. MMM YYYY";
    
    return formatter.string(from: date)
}

func getTime(dateString: String) -> String {
    let date = ISO8601DateFormatter().date(from: dateString)!;
    
    let formatter = DateFormatter();
    formatter.dateFormat = "HH:mm"
    
    return formatter.string(from: date)
}

#Preview {
    RaceDetails(race: RaceData(), flags: [:])
}
