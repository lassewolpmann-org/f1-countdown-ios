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
    let session: SessionData
    
    var body: some View {
        let day = getDayName(date: session.startDate);
        
        Section {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(day)
                        .foregroundStyle(.red)
                    Text(session.startDate, style: .date)
                    Text(DateInterval(start: session.startDate, end: session.endDate))
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                Divider()
                
                NotificationButton(session: session, race: race, series: series)
            }
        } header: {
            Text(session.formattedName)
        }
    }
}

#Preview {
    List {
        let race = RaceData();
        
        SessionDetails(race: race, series: "f1", session: SessionData())
    }
}
