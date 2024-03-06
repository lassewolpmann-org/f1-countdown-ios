//
//  SessionDetails.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 19.11.2023.
//

import SwiftUI

struct SessionDetails: View {
    let race: RaceData;
    let series: String;
    let name: String;
    let parsedName: String;
    let date: Date;
    
    var body: some View {
        let day = getDayName(date: date);
        let sessionLength = race.sessionLengths[series]?[name] ?? 60;
        let dateString = ISO8601DateFormatter().string(from: date);
        
        Section {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(day)
                        .foregroundStyle(.red)
                    Text(date, style: .date)
                    Text(DateInterval(start: date, end: date.addingTimeInterval(60 * sessionLength)))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                Divider()
                
                NotificationButton(sessionName: name, sessionDate: dateString, race: race, series: series)
            }
        } header: {
            Text(parsedName)
        }
    }
}

#Preview {
    List {
        let race = RaceData();
        let firstSession = race.futureSessions.first!;
        
        SessionDetails(race: race, series: "f1", name: firstSession.key, parsedName: parseSessionName(sessionName: firstSession.key), date: ISO8601DateFormatter().date(from: firstSession.value)!)
    }
}
