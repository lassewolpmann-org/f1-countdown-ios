//
//  CalendarRace.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 25.7.2024.
//

import SwiftUI

struct CalendarRace: View {
    let race: RaceData
    let previousRace: RaceData?
    let followingRace: RaceData?

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .center, spacing: 20) {
                VStack {
                    Text(race.title)
                        .font(.title2)
                        .bold()
                    
                    Text(race.location)
                        .font(.title3)
                }
                
                HStack {
                    if let previousRace {
                        if let previousRaceSession = previousRace.sortedSessions.last?.value.startDate,
                        let currentRaceSession = race.sortedSessions.last?.value.startDate {
                            let delta = currentRaceSession.timeIntervalSince(previousRaceSession)
                            let days = Int(round(delta / 86400))
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "arrow.left")
                                    Text(previousRace.flag)
                                }
                                
                                Text("\(days) days")
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if let followingRace {
                        if let followingRaceSession = followingRace.sortedSessions.last?.value.startDate,
                           let currentRaceSession = race.sortedSessions.last?.value.startDate {
                            let delta = followingRaceSession.timeIntervalSince(currentRaceSession)
                            let days = Int(round(delta / 86400))
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(followingRace.flag)
                                    Image(systemName: "arrow.right")
                                }
                                
                                Text("\(days) days")
                            }
                        }
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                
                Divider()
                
                ForEach(race.sortedSessions, id: \.key) { session in
                    VStack {
                        HStack {
                            Text(session.value.longName)
                                .foregroundStyle(.red)
                            Spacer()
                            Text(session.value.dayString)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            Text(session.value.dateString)
                            Spacer()
                            Text(DateInterval(start: session.value.startDate, end: session.value.endDate))
                        }
                    }
                    .strikethrough(session.value.endDate.timeIntervalSinceNow < 0)
                    .opacity(session.value.endDate.timeIntervalSinceNow < 0 ? 0.5 : 1.0)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 15)
        }
        .containerRelativeFrame(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial.shadow(.drop(radius: 3)))
        )
        .padding(.vertical, 15)
    }
}

#Preview {
    CalendarRace(race: RaceData(), previousRace: RaceData(), followingRace: RaceData())
}
