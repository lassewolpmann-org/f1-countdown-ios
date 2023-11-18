//
//  RaceSessions.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.11.2023.
//

import SwiftUI

struct RaceSessions: View {
    var sessions: [String: String];
    
    var body: some View {
        let sortedSessions = sessions.sorted(by:{$0.value < $1.value});
        
        List {
            ForEach(sortedSessions, id:\.key) { key, value in
                Section {
                    HStack {
                        Text(Image(systemName: "calendar"))
                        Text(getDay(dateString: value))
                    }
                    
                    HStack {
                        Text(Image(systemName: "clock"))
                        Text(getTime(dateString: value))
                    }
                    
                    Button("Add to calendar", systemImage: "calendar", action: createCalendarEntry)
                        .labelStyle(.titleAndIcon)
                    
                    Button("Alert", systemImage:"bell.fill", action: createAlert)
                        .labelStyle(.titleAndIcon)
                } header: {
                    Text(key.uppercased())
                        .font(.subheadline)
                }
            }
        }
    }
}

func createAlert() {
    print("Alert")
}

func createCalendarEntry() {
    print("Calendar Entry")
}

#Preview {
    RaceSessions(sessions: ["fp1" : "1970-01-01T00:00:00Z", "fp2" : "1970-01-01T00:00:01Z"])
}
