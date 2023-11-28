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
    
    var name: String;
    var date: Date;
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        
                        Text(getDayName(date: date))
                            .foregroundStyle(.red)
                        
                        Text(getOnlyDay(date: date))
                        
                        Text("from \(getTime(date: date))")
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    NotificationButton(raceName: race.name, sessionName: name, sessionDate: date)
                }
            }
        }
        
        Section {
            SessionWeather(race: race, flags: flags, sessionDate: date);
        } header: {
            Text("Forecast for \(name)")
        }
    }
}

#Preview {
    SessionDetails(race: RaceData(), flags: [:], name: parseSessionName(sessionName: RaceData().sessions.first!.key), date: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!)
}
