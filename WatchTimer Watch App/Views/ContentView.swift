//
//  ContentView.swift
//  WatchTimer Watch App
//
//  Created by Lasse Wolpmann on 17.4.2024.
//

import SwiftUI

struct ContentView: View {
    let allRaces: [String: [RaceData]]
    let notificationController: NotificationController
    
    @State var currentDate: Date = Date()
    @State var selectedSeries: String = "f1"
    
    var nextRace: RaceData? {
        guard let currentSeries = allRaces[selectedSeries] else { return nil }

        let currentYear = Calendar.current.component(.year, from: Date())
        let currentSeason = currentSeries.filter { $0.season == currentYear }
        let futureRaces = currentSeason.filter { $0.endDate > currentDate }
        let sortedRaces = futureRaces.sorted { $0.startDate < $1.startDate }
        
        return sortedRaces.first
    }
    
    
    var body: some View {
        TabView {
            if let nextRace {
                ForEach(nextRace.race.sessions, id: \.shortName) { session in
                    SessionView(flag: nextRace.race.flag, session: session, currentDate: currentDate)
                }
            } else {
                VStack {
                    Text("No data available for \(selectedSeries.uppercased()).")
                }
            }
            
            Picker(selection: $selectedSeries) {
                ForEach(availableSeries, id:\.self) { series in
                    Text(series.uppercased())
                }
            } label: {
                Text("Select Series")
            }
            .sensoryFeedback(.selection, trigger: selectedSeries)
            .pickerStyle(.navigationLink)
        }
        .tabViewStyle(.verticalPage)
        .onAppear {
            guard let nextRace else { return }
            
            for session in nextRace.race.sessions {
                DispatchQueue.main.asyncAfter(deadline: .now() + session.startDate.timeIntervalSinceNow) {
                    currentDate = .now
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + session.endDate.timeIntervalSinceNow) {
                    currentDate = .now
                }
            }
        }
    }
}

struct SessionView: View {
    let flag: String
    let session: Season.Race.Session
    let currentDate: Date
    
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
        VStack(alignment: .leading, spacing: 5) {
            VStack(alignment: .leading) {
                Text("\(flag) \(session.longName)")
                    .font(.headline)
                    .foregroundStyle(.red)
                
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
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "calendar")

                VStack(alignment: .leading) {
                    Text(session.dayString)
                    Text(session.dateString)
                }
            }
            
            Label {
                Text(DateInterval(start: session.startDate, end: session.endDate))
            } icon: {
                Image(systemName: "clock")
            }
            
            Divider()
            
            if (sessionStatus == .upcoming) {
                Text("Starts in \(session.startDate, style: .relative)")
            } else if (sessionStatus == .ongoing) {
                Text("Ends in \(session.endDate, style: .relative)")
            } else {
                Text("Session has ended.")
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ContentView(allRaces: ["f1": sampleRaces], notificationController: NotificationController())
}
