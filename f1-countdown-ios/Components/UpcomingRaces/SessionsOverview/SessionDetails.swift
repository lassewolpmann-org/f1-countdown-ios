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
    let name: String;
    let parsedName: String;
    let date: Date;
    let config: APIConfig;
    
    var body: some View {
        let day = getDayName(date: date);
        let dateString = getDate(date: date);
        
        let startTime = getTime(date: date);
        let sessionLength = Double(config.sessionLengths[name] ?? Int(60.0));
        let endTime = getTime(date: date.addingTimeInterval(60 * sessionLength));
        
        Section {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(day)
                                .foregroundStyle(.red)
                            
                            Text(dateString)
                        }
                    
                        Text("from \(startTime) to \(endTime)")
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    NotificationButton(raceName: race.name, sessionName: parsedName, sessionDate: date)
                }
            }
        }
        
        Section {
            SessionWeather(race: race, flags: flags, sessionDate: date);
        } header: {
            Text("Forecast for \(parsedName)")
        }
    }
}

#Preview {
    SessionDetails(race: RaceData(), flags: [:], name: RaceData().sessions.first!.key, parsedName: parseSessionName(sessionName: RaceData().sessions.first!.key), date: ISO8601DateFormatter().date(from: RaceData().sessions.first!.value)!, config: APIConfig())
}
