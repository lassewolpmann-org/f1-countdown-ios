//
//  UpcomingTabRaceView.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 1.1.2025.
//

import SwiftUI

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
    ScrollView {
        UpcomingTabRaceView(showSessions: true, race: sampleRaces.first!, notificationController: NotificationController())
    }
}
