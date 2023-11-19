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
    var race: RaceData;
    
    @State var firstSessionName: String?;
    @State var firstSessionDate: String?;
    
    @State var futureSessions = RaceData().sessions.sorted(by:{$0.value < $1.value});
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    SessionDetails(raceName: race.name, sessionName: firstSessionName, sessionDate: firstSessionDate)
                } header: {
                    Text("Upcoming Session")
                }
                
                Section {
                    SessionWeather(latitude: race.latitude, longitude: race.longitude, raceLocation: race.location, sessionDate: firstSessionDate);
                } header: {
                    Text("Forecast for \(parseSessionName(sessionName: firstSessionName))")
                } footer: {
                    Text("Forecast becomes available within 10 days of session date.")
                }
                
                if (futureSessions.count > 0) {
                    Section(header: Text("Following sessions")) {
                        ForEach(futureSessions.sorted(by:{$0.value < $1.value}), id: \.key) { session in
                            SessionDetails(raceName: race.name, sessionName: session.key, sessionDate: session.value)
                        }
                    }
                }
            }
            .navigationTitle("\(race.name) Grand Prix")
            .onAppear {
                let sortedSessions = race.sessions.sorted(by:{$0.value < $1.value});

                futureSessions = sortedSessions.filter { (key: String, value: String) in
                    let currentDate = Date();
                    let sessionDate = formatDate(dateString: value);
                    
                    let currentTimestamp = currentDate.timeIntervalSince1970;
                    let sessionTimestamp = sessionDate.timeIntervalSince1970;
                    
                    return currentTimestamp < sessionTimestamp
                }
                
                
                if (futureSessions.count > 0) {
                    let firstSession = futureSessions.removeFirst();
                    
                    firstSessionName = firstSession.key;
                    firstSessionDate = firstSession.value;
                } else {
                    let firstSession = sortedSessions.first;
                    
                    firstSessionName = firstSession?.key;
                    firstSessionDate = firstSession?.value;
                }
            }
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
    let date = formatDate(dateString: dateString);
    
    let formatter = DateFormatter();
    formatter.dateFormat = "EEEE dd. MMM YYYY";
    
    return formatter.string(from: date)
}

func getTime(dateString: String) -> String {
    let date = formatDate(dateString: dateString);
    
    let formatter = DateFormatter();
    formatter.dateFormat = "HH:mm"
    
    return formatter.string(from: date)
}

#Preview {
    RaceDetails(race: RaceData())
}
