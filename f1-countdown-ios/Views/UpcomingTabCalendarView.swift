//
//  UpcomingTabCalendarView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 25.3.2025.
//

import SwiftUI
import SwiftData

struct CalendarSessionData {
    var id: UUID = UUID()
    var session: Season.Race.Session
    var raceTitle: String
    var series: String
    var tbc: Bool
}

struct UpcomingTabCalendarView: View {
    @Query var allRaces: [RaceData]
    var calendarSessionData: [CalendarSessionData] {
        var allSessions: [CalendarSessionData] = []
        
        allRaces.forEach { race in
            race.race.futureSessions.forEach { session in
                allSessions.append(CalendarSessionData(session: session, raceTitle: race.race.title, series: race.series, tbc: race.tbc))
            }
        }
        
        return allSessions.sorted(by: { $0.session.startDate < $1.session.startDate })
    }
    
    var groupedByDate: [Date: [CalendarSessionData]] {
        let calendar = Calendar.current
        let groupedByDate = calendarSessionData.reduce(into: [Date: [CalendarSessionData]]()) {
            let sessionDate = $1.session.startDate
            let startOfDay = calendar.startOfDay(for: sessionDate)

            if ($0[startOfDay] == nil) {
                $0[startOfDay] = []
            }
            
            $0[startOfDay]?.append($1)
        }

        return groupedByDate
    }
    
    var body: some View {
        List(groupedByDate.sorted(by: { $0.key < $1.key }), id: \.key) { group in
            Section {
                ForEach(group.value, id: \.id) { data in
                    HStack {
                        Text("\(data.series.uppercased()) - \(data.session.longName)")
                        
                        Spacer()
                        
                        if (data.tbc) {
                            Text("TBC")
                        } else {
                            Text(data.session.startDate, style: .time)
                        }
                    }
                }
            } header: {
                Text("\(group.key, style: .date) - \(group.value.first?.raceTitle ?? "")")
            }
        }
    }
}

#Preview(traits: .sampleData) {
    UpcomingTabCalendarView()
}
