//
//  UpcomingTabRaceView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 1.1.2025.
//

import SwiftUI

struct UpcomingTabRaceView: View {
    @State var showSessions: Bool = false
    
    let race: Season.Race
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(race.title)
                
                Spacer()
                
                Button {
                    showSessions.toggle()
                } label: {
                    Image(systemName: showSessions ? "eye.slash" : "eye")
                }
            }
            
            if (showSessions) {
                ForEach(race.sessions, id: \.shortName) { session in
                    VStack {
                        HStack {
                            Text(session.longName)
                                .foregroundStyle(.red)
                            Spacer()
                            Text(session.dayString)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text(session.dateString)
                            Spacer()
                            Text(DateInterval(start: session.startDate, end: session.endDate))
                        }
                    }
                    .strikethrough(session.endDate.timeIntervalSinceNow < 0)
                    .opacity(session.endDate.timeIntervalSinceNow < 0 ? 0.5 : 1.0)
                }
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    ScrollView {
        if let race = sampleRaces.first?.race {
            UpcomingTabRaceView(showSessions: true, race: race)
        }
    }
}
