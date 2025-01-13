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
    
    let race: RaceData
    let notificationController: NotificationController

    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(race.race.title)
                
                Spacer()
                
                Button {
                    notificationsAddedFeedback.toggle()

                    Task {
                        for session in race.race.sessions {
                            let success = await notificationController.addSessionNotifications(race: race, session: session)
                            guard success == true else { return }
                        }
                        
                        notificationsAdded = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            notificationsAdded = false
                        }
                    }
                } label: {
                    Image(systemName: notificationsAdded ? "checkmark" : "bell")
                        .foregroundStyle(notificationsAdded ? .green : .blue)
                }
                .sensoryFeedback(.success, trigger: notificationsAddedFeedback)
                .animation(.linear(duration: 0.2), value: notificationsAdded)
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
    }
}

#Preview {
    ScrollView {
        UpcomingTabRaceView(showSessions: true, race: sampleRaces.first!, notificationController: NotificationController())
    }
}
