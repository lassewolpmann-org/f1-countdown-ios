//
//  SessionDetails.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct SessionDetails: View {
    let race: RaceData;
    let flags: [String: String]
    
    var sessionName: String;
    var sessionDate: String;
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(getDay(dateString: sessionDate))
                        Text("from \(getTime(dateString: sessionDate))")
                    }
                    
                    Spacer()
                    
                    NotificationButton(raceName: race.name, sessionName: sessionName, sessionDate: sessionDate)
                }
            }
        } header: {
            Text(parseSessionName(sessionName: sessionName))
        }
        
        Section {
            SessionWeather(race: race, flags: flags, sessionDate: sessionDate);
        } header: {
            Text("Forecast for \(parseSessionName(sessionName: sessionName))")
        }
    }
}

#Preview {
    SessionDetails(race: RaceData(), flags: [:], sessionName: RaceData().sessions.first!.key, sessionDate: RaceData().sessions.first!.value)
}
