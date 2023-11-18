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
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    VStack(alignment: .leading) {
                        Text(parseSessionName(sessionName: firstSessionName))
                            .font(.title)
                            .padding(.bottom, 5)
                        
                        Text(getDay(dateString: firstSessionDate ?? "1970-01-01T00:00:00Z"))
                        Text("from \(getTime(dateString: firstSessionDate ?? "1970-01-01T00:00:00Z"))")
                    }
                } header: {
                    Text("Upcoming Session")
                }
                
                Section {
                    SessionWeather(latitude: race.latitude, longitude: race.longitude, sessionDate: firstSessionDate);
                } header: {
                    Text("Forecast for \(parseSessionName(sessionName: firstSessionName))")
                } footer: {
                    Text("Forecast becomes available within 10 days of session date.")
                }
                
                NavigationLink("All Sessions") {
                    RaceSessions(sessions: race.sessions)
                }
            }
            .navigationTitle("\(race.name) Grand Prix")
            .onAppear {
                let sortedSessions = race.sessions.sorted(by:{$0.value < $1.value});
                
                let futureSessions = sortedSessions.filter { (key: String, value: String) in
                    let currentDate = Date();
                    let sessionDate = formatDate(dateString: value);
                    
                    let currentTimestamp = currentDate.timeIntervalSince1970;
                    let sessionTimestamp = sessionDate.timeIntervalSince1970;
                    
                    return currentTimestamp < sessionTimestamp
                }
                
                let firstSession = futureSessions.first;
                
                firstSessionName = firstSession?.key;
                firstSessionDate = firstSession?.value;
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
    RaceDetails(race: RaceData(name: "Preview", location: "Preview location", latitude: 0.0, longitude: 0.0, round: 0, slug: "preview-grand-prix", localeKey: "preview", sessions: ["fp1" : "1970-01-01T00:00:00Z", "fp2" : "1970-01-01T00:00:01Z"]))
}
