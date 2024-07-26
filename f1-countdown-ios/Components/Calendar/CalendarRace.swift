//
//  CalendarRace.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 25.7.2024.
//

import SwiftUI

struct CalendarRace: View {
    let race: RaceData

    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial.shadow(.drop(radius: 3)))
            .containerRelativeFrame(.horizontal)
            .overlay {
                VStack(alignment: .center, spacing: 30) {
                    VStack {
                        Text(getRaceTitle(race: race))
                            .font(.title)
                            .bold()
                        
                        Text(race.location)
                            .font(.headline)
                    }
                    
                    Divider()
                    
                    ForEach(race.sortedSessions, id: \.key) { session in
                        let sessionDate = SessionDate(d: session.value.startDate)
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(sessionDate.dateString)
                                Text(sessionDate.timeString)
                            }
                            
                            Spacer()
                            Text(session.value.formattedName)
                                .bold()
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
}

#Preview {
    CalendarRace(race: RaceData())
}
