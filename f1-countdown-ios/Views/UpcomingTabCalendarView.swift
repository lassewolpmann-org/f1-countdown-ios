//
//  UpcomingTabCalendarView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 25.3.2025.
//

import SwiftUI
import SwiftData

struct Month {
    struct Week {
        struct Day {
            struct Session: Identifiable {
                var id: UUID = UUID()
                var session: Season.Race.Session
                var race: RaceData
            }
            
            var date: Date
            var sessions: [Month.Week.Day.Session]
        }
        
        var days: [Int: Month.Week.Day]
    }
    
    var name: String
    var weeks: [Int: Month.Week]
}

struct UpcomingTabCalendarView: View {
    @Query var allRaces: [RaceData]
    
    let calendar = Calendar.current
    let notificationController: NotificationController
    
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
    
    var months: [Int: Month] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        
        var months: [Int: Month] = [:]
        
        for date in allDaysInYear {
            let month = calendar.component(.month, from: date)
            let week = calendar.component(.weekOfMonth, from: date)
            let day = calendar.component(.day, from: date)
         
            if (months[month] == nil) { months[month] = Month(name: formatter.string(from: date), weeks: [:]) }
            if (months[month]?.weeks[week] == nil) { months[month]?.weeks[week] = Month.Week(days: [:]) }
            if (months[month]?.weeks[week]?.days[day] == nil) { months[month]?.weeks[week]?.days[day] = Month.Week.Day(date: date, sessions: []) }
        }
        
        for race in allRaces {
            let sessions = race.race.sessions
            
            for session in sessions {
                let startDate = session.startDate
                let month = calendar.component(.month, from: startDate)
                let week = calendar.component(.weekOfMonth, from: startDate)
                let day = calendar.component(.day, from: startDate)
                
                months[month]?.weeks[week]?.days[day]?.sessions.append(Month.Week.Day.Session(session: session, race: race))
            }
        }
        
        return months
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(months.sorted(by: { $0.key < $1.key }), id: \.key) { month in
                        MonthView(month: month.value, notificationController: notificationController)
                    }
                }
            }
            .navigationTitle("\(calendar.component(.year, from: Date.now).description) Calendar")
            .padding(.horizontal)
        }
    }
}

struct MonthView: View {
    let month: Month
    let notificationController: NotificationController
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(month.name).bold()
            
            Grid {
                DaysOfWeek()
                
                ForEach(month.weeks.sorted(by: { $0.key < $1.key }), id: \.key) { week in
                    WeekView(week: week.value, notificationController: notificationController)
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

struct WeekView: View {
    let week: Month.Week
    let notificationController: NotificationController
    
    var body: some View {
        Divider()
        
        GridRow {
            ForEach(week.days.sorted(by: { $0.key < $1.key }), id: \.key) { day in
                if (day.key == 1) {
                    let diff = 7 - week.days.count
                    
                    ForEach(0..<diff, id: \.self) { _ in
                        Text("")
                    }
                }
                
                DayView(day: day, notificationController: notificationController)
            }
        }
    }
}

struct DayView: View {
    @State private var showSheet = false
    
    let day: [Int: Month.Week.Day].Element
    let notificationController: NotificationController
    
    var body: some View {
        let dayNumber = day.key
        let sessions = day.value.sessions
        let date = day.value.date
        
        var isDateToday: Bool {
            let calendar = Calendar.current
            
            return calendar.startOfDay(for: date) == calendar.startOfDay(for: Date.now)
        }
        
        Button {
            showSheet.toggle()
        } label: {
            VStack {
                Text(dayNumber.description)
                Text(!sessions.isEmpty ? sessions.first?.race.race.flag ?? "🏳️" : " ")
            }
            .frame(width: 35)
        }
        .disabled(sessions.isEmpty)
        .sheet(isPresented: $showSheet) {
            SessionsOfDayView(sessions: sessions, notificationController: notificationController)
                .presentationDetents([.medium])
        }
        .background(
            RoundedRectangle(cornerRadius: 5)
                .fill(isDateToday ? .red.opacity(0.1) : .clear)
        )
    }
}

struct SessionsOfDayView: View {
    let sessions: [Month.Week.Day.Session]
    let notificationController: NotificationController

    var title: String {
        guard let race = sessions.first?.race.race else { return "Sessions" }
        
        return "\(race.flag) \(race.location)"
    }
    
    var body: some View {
        NavigationStack {
            List(sessions.sorted(by: { $0.session.startDate < $1.session.startDate })) { session in
                var sessionStatus: Season.Race.Session.Status {
                    let currentDate = Date.now
                    
                    if (currentDate >= session.session.endDate) {
                        return .finished
                    } else if (currentDate >= session.session.startDate && currentDate < session.session.endDate) {
                        return .ongoing
                    } else {
                        return .upcoming
                    }
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(session.race.series.uppercased()).bold()
                        Text(session.session.longName)
                    }
                    
                    Spacer()
                    
                    if (session.race.tbc) {
                        Text("TBC")
                    } else {
                        VStack(alignment: .trailing) {
                            Text(session.session.startDate, style: .time)
                            Text(session.session.endDate, style: .time).foregroundStyle(.secondary)
                        }
                        
                        NotificationButton(session: session.session, sessionStatus: sessionStatus, race: session.race, notificationController: notificationController)
                    }
                }
            }
            .navigationTitle(title)
        }
    }
}

struct DaysOfWeek: View {
    var body: some View {
        GridRow {
            Text("M")
            Text("T")
            Text("W")
            Text("T")
            Text("F")
            Text("S")
            Text("S")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
}

#Preview(traits: .sampleData) {
    UpcomingTabCalendarView(notificationController: NotificationController())
}
