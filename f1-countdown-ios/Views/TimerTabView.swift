//
//  SessionsTab.swift
//  f1-countdown-ios
//
//  Created by Lasse Wolpmann on 17.12.2023.
//

import SwiftUI

struct TimerTabView: View {
    let seriesRaces: [RaceData]
    @State var currentDate: Date = .now
    
    var nextRace: RaceData? {
        let currentYear = Calendar(identifier: .gregorian).component(.year, from: .now)
        let currentSeries = seriesRaces.filter { $0.series == selectedSeries }
        let currentSeason = currentSeries.filter { $0.season == currentYear }
        let futureRaces = currentSeason.filter { $0.endDate > currentDate }
        let sortedRaces = futureRaces.sorted { $0.startDate < $1.startDate }
        
        return sortedRaces.first
    }
    
    let selectedSeries: String
    let notificationController: NotificationController
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let nextRace {
                    VStack(alignment: .center, spacing: 15) {
                        ForEach(nextRace.race.sessions, id: \.shortName) { session in
                            SessionView(nextRace: nextRace, session: session, currentDate: currentDate, notificationController: notificationController)
                        }
                    }
                    .background(FlagBackgroundView(flag: nextRace.race.flag))
                    .padding(.horizontal, 10)
                    .navigationTitle(nextRace.race.title)
                } else {
                    Label {
                        Text("It seems like there is no data available to display here.")
                    } icon: {
                        Image(systemName: "exclamationmark.triangle.fill")
                    }
                    .bold()
                    .symbolRenderingMode(.multicolor)
                    .navigationTitle("Timer")
                }
            }
        }
        .onAppear {
            guard let nextRace else { return }
            
            for session in nextRace.race.sessions {
                DispatchQueue.main.asyncAfter(deadline: .now() + session.startDate.timeIntervalSinceNow) {
                    currentDate = Date()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + session.endDate.timeIntervalSinceNow) {
                    currentDate = Date()
                }
            }
        }
        .refreshable {
            currentDate = Date()
        }
    }
}

struct SessionView: View {
    let nextRace: RaceData
    let session: Season.Race.Session
    let currentDate: Date
    let notificationController: NotificationController
    
    var sessionStatus: Season.Race.Session.Status {
        if (currentDate >= session.endDate) {
            return .finished
        } else if (currentDate >= session.startDate && currentDate < session.endDate) {
            return .ongoing
        } else {
            return .upcoming
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text(session.longName)
                    .font(.headline)
                    .foregroundStyle(.red)
                
                Spacer()
                
                Label {
                    Text(sessionStatus.rawValue)
                } icon: {
                    switch sessionStatus {
                    case .finished:
                        Image(systemName: "flag.checkered.2.crossed")
                    case .ongoing:
                        Image(systemName: "flag.checkered")
                    case .upcoming:
                        Image(systemName: "clock")
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Label {
                        Text("\(session.dayString), \(session.dateString)")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    
                    Label {
                        Text(DateInterval(start: session.startDate, end: session.endDate))
                    } icon: {
                        Image(systemName: "clock")
                    }
                }
                
                Spacer()
                
                NotificationButton(session: session, sessionStatus: sessionStatus, race: nextRace, notificationController: notificationController)
            }
            .font(.body)
            
            HStack {
                if (sessionStatus == .upcoming) {
                    Text("Session starts in \(session.startDate, style: .relative)")
                } else if (sessionStatus == .ongoing) {
                    Text("Session ends in \(session.endDate, style: .relative)")
                } else {
                    Text("Session has ended.")
                }
                
                Spacer()
            }
            .font(.callout)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
        )
    }
}

struct FlagBackgroundView: View {
    let flag: String
    
    var body: some View {
        GeometryReader { geo in
            Text(flag)
                .font(.system(size: 1000))
                .minimumScaleFactor(0.005)
                .lineLimit(1)
                .frame(width: geo.size.width, height: geo.size.height)
                .rotationEffect(.degrees(90))
                .blur(radius: 50)
        }
    }
}

#Preview {
    TimerTabView(seriesRaces: sampleRaces, selectedSeries: "f1", notificationController: NotificationController())
}
