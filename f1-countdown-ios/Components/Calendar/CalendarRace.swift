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
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial.shadow(.drop(radius: 3)))
            .containerRelativeFrame(.horizontal)
            .overlay {
                VStack(alignment: .center, spacing: 30) {
                    VStack {
                        Text(getRaceTitle(race: race))
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
                    .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    ForEach(race.sortedSessions, id: \.key) { session in
                        let sessionDate = SessionDate(d: session.value.startDate)
                        
                        VStack {
                            HStack {
                                Text(session.value.formattedName)
                                    .foregroundStyle(.red)
                                Spacer()
                                Text(sessionDate.dayString)
                                    .foregroundStyle(.secondary)
                            }
                            
                            HStack {
                                Text(sessionDate.dateString)
                                Spacer()
                                Text(DateInterval(start: session.value.startDate, end: session.value.endDate))
                            }
                        }
                        .strikethrough(session.value.endDate.timeIntervalSinceNow < 0)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 15)
            }
            .padding(.vertical, 15)
    }
}

struct SessionDate {
    let date: Date
    let dateFormatter = DateFormatter()
    
    init(d: Date) {
        self.date = d
    }
    
    var dateString: String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date)
    }
    
    var timeString: String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
    var dayString: String {
        dateFormatter.dateFormat = "EEEE"
        
        return dateFormatter.string(from: date)
    }
}

#Preview {
    CalendarRace(race: RaceData(), previousRace: RaceData(), followingRace: RaceData())
}
