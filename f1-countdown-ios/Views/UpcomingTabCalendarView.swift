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
    var flag: String
    var series: String
    var tbc: Bool
}

struct UpcomingTabCalendarView: View {
    @Query var allRaces: [RaceData]
    
    let calendar = Calendar.current

    var calendarSessionData: [CalendarSessionData] {
        var allSessions: [CalendarSessionData] = []
        
        allRaces.forEach { race in
            race.race.sessions.forEach { session in
                allSessions.append(CalendarSessionData(session: session, raceTitle: race.race.title, flag: race.race.flag, series: race.series, tbc: race.tbc))
            }
        }
        
        return allSessions.sorted(by: { $0.session.startDate < $1.session.startDate })
    }
    
    var sessionsGroupedByDate: [Date: [CalendarSessionData]] {
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
    
    var allDaysInYear: [Date] {
        guard let yearRange = calendar.range(of: .day, in: .year, for: Date()) else { return [] }
        guard let firstDayOfYear = calendar.date(from: calendar.dateComponents([.year], from: Date())) else { return [] }
        
        var dates: [Date] = []
        var date = firstDayOfYear
        for _ in yearRange {
            dates.append(date)
            guard let newDate = calendar.date(byAdding: .day, value: 1, to: date) else { continue }
            date = newDate
        }
        
        return dates
    }
    
    var splitIntoMonths: [Int: [Date]] {
        return allDaysInYear.reduce(into: [Int: [Date]]()) { partialResult, date in
            let month = calendar.component(.month, from: date)
            
            if (partialResult[month] == nil) {
                partialResult[month] = []
            }
            
            partialResult[month]?.append(date)
        }
    }
    
    var splitIntoMonthsAndWeeks: [Int: [Int: [Date: [CalendarSessionData]]]] {
        return splitIntoMonths.reduce(into: [Int: [Int: [Date: [CalendarSessionData]]]]()) { partialResult, month in
            let monthIndex = month.key
            let daysInMonth = month.value
            
            let splitIntoWeeks = daysInMonth.reduce(into: [Int: [Date: [CalendarSessionData]]]()) { partialResult, date in
                let week = calendar.component(.weekOfMonth, from: date)

                if (partialResult[week] == nil) {
                    partialResult[week] = [:]
                }
                
                if let sessions = sessionsGroupedByDate[date] {
                    partialResult[week]?[date] = sessions
                } else {
                    partialResult[week]?[date] = []
                }
            }
            
            partialResult[monthIndex] = splitIntoWeeks
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    ForEach(splitIntoMonthsAndWeeks.sorted(by: { $0.key < $1.key }), id: \.key) { month in
                        let weeks = month.value
                        
                        VStack(alignment: .leading, spacing: 15) {
                            if let firstDayOfMonth = month.value.first?.value.first?.key {
                                var monthString: String {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMMM"
                                    
                                    return dateFormatter.string(from: firstDayOfMonth)
                                }
                                
                                Text(monthString)
                                    .bold()
                            }
                            
                            Grid(verticalSpacing: 10) {
                                GridRow {
                                    Text("M")
                                    Spacer()
                                    Text("T")
                                    Spacer()
                                    Text("W")
                                    Spacer()
                                    Text("T")
                                    Spacer()
                                    Text("F")
                                    Spacer()
                                    Text("S")
                                    Spacer()
                                    Text("S")
                                }
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                
                                ForEach(weeks.sorted(by: { $0.key < $1.key }), id: \.key) { week in
                                    Divider()
                                    
                                    GridRow {
                                        ForEach(week.value.sorted(by: { $0.key < $1.key }), id: \.key) { day in
                                            let date = day.key
                                            let sessions = day.value
                                            
                                            let dayNumber = calendar.component(.day, from: date)
                                            
                                            if (dayNumber == 1) {
                                                let diff = 7 - week.value.count
                                                
                                                ForEach(0..<diff, id: \.self) { _ in
                                                    Text("")
                                                    Spacer()
                                                }
                                            }
                                            
                                            if (sessions.count > 0) {
                                                NavigationLink {
                                                    List(sessions, id: \.id) { data in
                                                        HStack {
                                                            Text("\(data.series.uppercased()) - \(data.session.longName)")
                                                            
                                                            Spacer()
                                                            
                                                            if (data.tbc) {
                                                                Text("TBC")
                                                            } else {
                                                                Text(data.session.startDate, style: .time)
                                                            }
                                                        }
                                                    }.navigationTitle(sessions.first?.raceTitle ?? "")
                                                } label: {
                                                    VStack {
                                                        Text(dayNumber.description)
                                                        Text(sessions.first?.flag ?? "")
                                                            .font(.footnote)
                                                    }
                                                }
                                            } else {
                                                VStack {
                                                    Text(dayNumber.description)
                                                    Text(" ")
                                                        .font(.footnote)
                                                }
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.regularMaterial)
                        )
                    }
                }
                .padding(20)
            }
            .navigationTitle("Season Calendar")
        }
    }
}

#Preview(traits: .sampleData) {
    UpcomingTabCalendarView()
}
