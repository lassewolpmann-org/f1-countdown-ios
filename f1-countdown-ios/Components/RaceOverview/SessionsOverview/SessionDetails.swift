//
//  SessionDetails.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct SessionDetails: View {
    var race: RaceData;
    
    var sessionName: String?;
    var sessionDate: String?;
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(getDay(dateString: sessionDate ?? "1970-01-01T00:00:00Z"))
                        Text("from \(getTime(dateString: sessionDate ?? "1970-01-01T00:00:00Z"))")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    NotificationButton(raceName: race.name, sessionName: sessionName ?? "fp1", sessionDate: sessionDate ?? "1970-01-01T00:00:00Z")
                }
            }
        } header: {
            Text(parseSessionName(sessionName: sessionName ?? ""))
        }
        
        Section {
            SessionWeather(latitude: race.latitude, longitude: race.longitude, raceLocation: race.location, sessionDate: sessionDate);
        } header: {
            Text("Forecast for \(parseSessionName(sessionName: sessionName))")
        }
    }
}

#Preview {
    SessionDetails(race: RaceData())
}
