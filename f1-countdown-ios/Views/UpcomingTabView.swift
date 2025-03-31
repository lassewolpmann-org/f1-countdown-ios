//
//  CalendarTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 18.12.2023.
//

import SwiftUI

struct UpcomingTabView: View {
    let allRaces: [String: [RaceData]]
    let selectedSeries: String
    let notificationController: NotificationController

    var currentSeason: [RaceData] {
        guard let currentSeries = allRaces[selectedSeries] else { return [] }
        
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: .now)
        let currentSeason = currentSeries.filter { $0.season == currentYear }
        let futureRaces = currentSeason.filter { $0.endDate > Date() }
        let sortedRaces = futureRaces.sorted { $0.startDate < $1.startDate }
        
        if (searchFilter.isEmpty) { return sortedRaces }
        if (!searchFilter.contains(/^[a-zA-Z]+$/)) { return sortedRaces }   // Only allow alphabet, no numbers or special characters

        return sortedRaces.filter { $0.race.name.localizedStandardContains(searchFilter) || $0.race.location.localizedStandardContains(searchFilter) }
    }

    @State private var searchFilter: String = ""
    
    var body: some View {
        NavigationStack {
            if (currentSeason.isEmpty) {
                Label {
                    Text("It seems like there is no data available to display here.")
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                }
                .bold()
                .symbolRenderingMode(.multicolor)
                .navigationTitle("Current Season")
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        NavigationLink {
                            UpcomingTabCalendarView(allRaces: allRaces, notificationController: notificationController)
                        } label: {
                            Label {
                                Text("\(Calendar.current.component(.year, from: Date.now).description) Calendar")
                                Spacer()
                                Image(systemName: "chevron.right")
                            } icon: {
                                Image(systemName: "calendar")
                            }
                        }
                        .buttonStyle(.bordered)
                        
                        ForEach(currentSeason, id: \.race.slug) { race in
                            UpcomingTabRaceView(race: race, notificationController: notificationController)
                        }
                    }
                }
                .padding(.horizontal)
                .searchable(text: $searchFilter)
                .navigationTitle("\(currentSeason.first!.season.description) \(currentSeason.first!.series.uppercased()) Season")
            }
        }
    }
}

struct UpcomingTabRaceView: View {
    @State var showSessions: Bool = false
    @State private var notificationsAdded = false
    @State private var notificationsAddedFeedback = false
    @State private var existingNotifications = false
    
    let race: RaceData
    let notificationController: NotificationController

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                VStack(alignment: .leading) {
                    Text(race.race.title)
                    
                    if let firstSession = race.race.sessions.first, let lastSession = race.race.sessions.last {
                        Text("\(firstSession.dateStringWithoutYear) - \(lastSession.dateStringWithoutYear)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Button {
                    if (existingNotifications) {
                        let sessionDates: [String] = race.race.sessions.flatMap { session in
                            let datesWithOffsets = notificationController.selectedOffsetOptions.map { session.startDate.addingTimeInterval(Double($0 * -60)) }
                            return datesWithOffsets.map { $0.ISO8601Format() }
                        }
                        
                        notificationController.center.removePendingNotificationRequests(withIdentifiers: sessionDates)
                        existingNotifications = false
                    } else {
                        Task {
                            for session in race.race.sessions {
                                await notificationController.addSessionNotifications(race: race, session: session)
                                guard notificationController.returnMessage.success == true else { return }
                            }
                            
                            notificationsAdded = true
                            existingNotifications = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                notificationsAdded = false
                            }
                        }
                    }
                    notificationsAddedFeedback.toggle()
                } label: {
                    if (notificationsAdded) {
                        Image(systemName: "checkmark" )
                            .foregroundStyle(.green)
                    } else {
                        Image(systemName: existingNotifications ? "bell.slash" : "bell")
                            .foregroundStyle(existingNotifications ? .red : .blue)
                    }
                }
                .sensoryFeedback(.success, trigger: notificationsAddedFeedback)
                .animation(.linear(duration: 0.2), value: notificationsAdded)
                .animation(.linear(duration: 0.2), value: existingNotifications)
                .frame(width: 30, height: 30)
                .background(RoundedRectangle(cornerRadius: 5).fill(.quinary))
                
                Button {
                    showSessions.toggle()
                } label: {
                    Image(systemName: showSessions ? "eye.slash" : "eye")
                        .foregroundStyle(.blue)
                }
                .sensoryFeedback(.selection, trigger: showSessions)
                .animation(.linear(duration: 0.2), value: showSessions)
                .frame(width: 30, height: 30)
                .background(RoundedRectangle(cornerRadius: 5).fill(.quinary))
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.quaternary)
            )
            
            if (showSessions) {
                ForEach(race.race.sessions, id: \.shortName) { session in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(session.longName)
                                .foregroundStyle(.red)
                            
                            Spacer()
                            
                            Text(session.dayString)
                                .foregroundStyle(.secondary)
                        }
                                                
                        HStack {
                            Label {
                                Text(session.startDate, style: .date)
                            } icon: {
                                Image(systemName: "calendar")
                            }
                            
                            Spacer()
                            
                            Text(DateInterval(start: session.startDate, end: session.endDate))
                        }
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.quinary)
                    )
                    .strikethrough(session.endDate.timeIntervalSinceNow < 0)
                    .opacity(session.endDate.timeIntervalSinceNow < 0 ? 0.5 : 1.0)
                }
            }
        }
        .task {
            existingNotifications = await checkForExistingNotifications()
        }
    }
    
    func checkForExistingNotifications() async -> Bool {
        let futureSessionDates: [String] = race.race.futureSessions.flatMap { session in
            let datesWithOffsets = notificationController.selectedOffsetOptions.map { session.startDate.addingTimeInterval(Double($0 * -60)) }
            return datesWithOffsets.map { $0.ISO8601Format() }
        }
        
        let futureSessionDatesSet = Set(futureSessionDates)
        
        let currentNotifications = await notificationController.currentNotifications
        let notificationIDs = Set(currentNotifications.map { $0.identifier })
        let expectedNotificationCount = race.race.futureSessions.count * notificationController.selectedOffsetOptions.count
        
        return notificationIDs.intersection(futureSessionDatesSet).count == expectedNotificationCount
    }
}

#Preview {
    UpcomingTabView(allRaces: ["f1": sampleRaces], selectedSeries: "f1", notificationController: NotificationController())
}
